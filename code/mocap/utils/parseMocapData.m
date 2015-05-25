function out = parseMocapData(fname)
% works for single rigid body
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
		
		case 'info'
			switch data{2}
				case 'framecount'
					out.numFrames = str2double(data{3});
				case 'rigidbodycount'
					out.numBodies = str2double(data{3});
					if out.numBodies ~= 1
						error('EXPECTING ONE RIGID BODY ONLY.');
					end
				otherwise
			end
			
		case 'rigidbody'
			if isnan(str2double(data{2}))
				% general rigid body details
				out.numMarkers = str2double(data{4});
				out.relMarkerPosn = zeros(3,out.numMarkers);
				for i = 1:out.numMarkers
					offsetId = 4+3*(i-1);
					x = str2double(data{offsetId+1});
					y = str2double(data{offsetId+2});
					z = str2double(data{offsetId+3});
					out.relMarkerPosn(:,i) = [x; y; z];
				end
			else 
				% extended info for rigid body in current frame
				frameId = str2double(data{2})+1;
				clear rbody
				rbody.tStamp = str2double(data{3});
				% concern if this is neq 0
				rbody.framesSinceTracked = str2double(data{6}); 
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
				out.rbody(frameId) = rbody;
			end
			
		case 'frame'
			frameId = str2double(data{2})+1;
			clear frame
			frame.tStamp = str2double(data{3});
			frame.rigidBodyDetected = str2double(data{4});
			if frame.rigidBodyDetected
				% rigid body xyz posn
				frame.p = [str2double(data{6}), str2double(data{7}), str2double(data{8})]';
				% quaternion
				frame.q = [str2double(data{9}), str2double(data{10}), str2double(data{11}), str2double(data{12})]';
				% rpy
				frame.rpy = [str2double(data{13}), str2double(data{14}), str2double(data{15})]';
				id = 16;
			else
				frame.p = [];
				frame.q = [];
				frame.rpy = [];
				id = 5;
			end
			frame.numVisibleMarkers = str2double(data{id});
			frame.markerIds = zeros(frame.numVisibleMarkers,1);
			frame.markerPosns = zeros(3,frame.numVisibleMarkers);
			for i = 1:frame.numVisibleMarkers
				offsetId = id+5*(i-1);
				x = str2double(data{offsetId+1});
				y = str2double(data{offsetId+2});
				z = str2double(data{offsetId+3});
				frame.markerPosns(:,i) = [x; y; z];
				frame.markerIds(i) = str2double(data{offsetId+4});
				% ignoring data{offsetId+5}, which is marker name
			end
			out.frames(frameId) = frame;
		otherwise 
	end
	line = fgetl(fid);
end
fclose(fid);
end