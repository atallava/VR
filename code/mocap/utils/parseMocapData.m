function out = parseMocapData(fname)
%PARSEMOCAPDATA Structifies optitrack motive data.
% 
% out = PARSEMOCAPDATA(fname)
% 
% fname - File name of exported trajectory data (csv).
% 
% out   - Structure.

if isempty(strfind(fname,'.csv'))
	fname = [fname '.csv'];
end
fid = fopen(fname);
line = fgetl(fid);
lineNum = 0;
while ischar(line)
	lineNum = lineNum+1;
	data = 	strsplit(line,',');
	dataType = data{1};
	switch dataType
		
		case 'comment'
			% do nothing
			
		case 'righthanded'
			out.handedness = 'righthanded';
			
		case 'lefthanded'
			out.handedness = 'lefthanded';
		
		case 'info'
			switch data{2}
				case 'framecount'
					out.frameCount = str2double(data{3});
				case 'rigidbodycount'
					out.rigidBodyCount = str2double(data{3});
					rigidBodyDetail = cell(1,out.rigidBodyCount);
					rigidBody = cell(1,out.rigidBodyCount);
					for i = 1:out.rigidBodyCount
						rigidBody{i} = struct('timeStamp',{},'name',{},'id',{}, ...
							'framesSinceLastTracked',{},'markerCount',{},'markerIds',{},'markerPosns',{}, ...
							'pcPosns',{},'markerTracked',{},'markerQuality',{},'meanError',{});						
					end
				otherwise
			end
			
		case 'rigidbody'
			if isnan(str2double(data{2}))
				% rigid body detail
				detail.name = data{2};
				detail.id = str2double(data{3});
				detail.markerCount = str2double(data{4});
				detail.relMarkerPosn = zeros(3,detail.markerCount);
				for j = 1:detail.markerCount
					offsetId = 4+3*(j-1);
					x = str2double(data{offsetId+1});
					y = str2double(data{offsetId+2});
					z = str2double(data{offsetId+3});
					detail.relMarkerPosn(:,j) = [x; y; z];
				end
				rigidBodyDetail{detail.id} = detail;
			else
				% extended info for rigid body in current frame
				frameIndex = str2double(data{2})+1;
				clear rbody
				rbody.timeStamp = str2double(data{3});
				rbody.name = data{4};
				rbody.id = str2double(data{5});
				% concern if this is neq 0?
				rbody.framesSinceLastTracked = str2double(data{6});
				% should this ever change?
				rbody.markerCount = str2double(data{7});
				rbody.markerIds = zeros(rbody.markerCount,1);
				rbody.markerPosns = zeros(3,rbody.markerCount);
				for i = 1:rbody.markerCount
					offsetId = 7+4*(i-1);
					x = str2double(data{offsetId+1});
					y = str2double(data{offsetId+2});
					z = str2double(data{offsetId+3});
					rbody.markerPosns(:,i) = [x; y; z];
					rbody.markerIds(i) = str2double(data{offsetId+4});
				end
				% point cloud positions
				id = 7+4*rbody.markerCount;
				rbody.pcPosns = zeros(3,rbody.markerCount);
				for i = 1:rbody.markerCount
					offsetId = id+3*(i-1);
					x = str2double(data{offsetId+1});
					y = str2double(data{offsetId+2});
					z = str2double(data{offsetId+3});
					rbody.pcPosns(:,i) = [x; y; z];
				end
				% were markers tracked or not?
				id = id+3*rbody.markerCount;
				rbody.markerTracked = zeros(rbody.markerCount,1);
				for i = 1:rbody.markerCount
					rbody.markerTracked(i) = str2double(data{id+i});
				end
				% marker quality
				id = id+rbody.markerCount;
				rbody.markerQuality = zeros(rbody.markerCount,1);
				for i = 1:rbody.markerCount
					rbody.markerQuality(i) = str2double(data{id+i});
				end
				rbody.meanError = str2double(data{end});
				rigidBody{rbody.id}(frameIndex) = rbody;
			end
			
		case 'frame'
			frameIndex = str2double(data{2})+1;
			clear frame
			frame.timeStamp = str2double(data{3});
			frame.rigidBodyCount = str2double(data{4});
			
			if ~frame.rigidBodyCount
				% no rigid bodies detected
				frame.rigidBody = {};
				offsetId = 5;
			else
				thisFrameRigidBody = cell(1,frame.rigidBodyCount);
				% pose of each rigid body detected
				for i = 1:frame.rigidBodyCount
					offsetId = 4+10*(i-1);
					thisFrameRigidBody{i}.id = str2double(data{offsetId+1});
					x = str2double(data{offsetId+2});
					y = str2double(data{offsetId+3});
					z = str2double(data{offsetId+4});
					thisFrameRigidBody{i}.xyz = [x; y; z];
					qx = str2double(data{offsetId+5});
					qy = str2double(data{offsetId+6});
					qz = str2double(data{offsetId+7});
					qw = str2double(data{offsetId+8});
					thisFrameRigidBody{i}.q = [qx; qy; qz; qw];
					y = str2double(data{offsetId+9});
					p = str2double(data{offsetId+10});
					r = str2double(data{offsetId+11});
					thisFrameRigidBody{i}.rpy = [y; p; r];
				end
				frame.rigidBody = thisFrameRigidBody;
				offsetId = offsetId+11*frame.rigidBodyCount+1;
			end
			
			% marker information
			frame.markerCount = str2double(data{offsetId});
			frame.markerPosns = zeros(3,frame.markerCount);
			frame.markerIds = zeros(1,frame.markerCount);
			frame.markerNames = cell(1,frame.markerCount);
			for i = 1:frame.markerCount
				x = str2double(data{offsetId+1});
				y = str2double(data{offsetId+2});
				z = str2double(data{offsetId+3});
				frame.markerPosns(:,i) = [x; y; z];
				frame.markerIds(i) = str2double(data{offsetId+4});
				frame.markerNames{i} = data{offsetId+5};
				offsetId = offsetId+5;
			end
								
			out.frame(frameIndex) = frame;
		otherwise 
			error('UNEXPECTED DATA TYPE.');
	end
	line = fgetl(fid);
end
out.rigidBodyDetail = rigidBodyDetail;
out.rigidBody = rigidBody;
fclose(fid);
end