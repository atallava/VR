% run on the neato to collect data
% initialize
if ~exist('rob','var')
    error('ROB MUST EXIST IN WORKSPACE');
end
% laser must be on
if ~isfield(rob.laser.data,'header')
    error('LASER MUST BE ON!');
end
% map must be present in environment
if ~exist('map','var')
    error('MAP MUST EXIST IN WORKSPACE');
end
if ~exist('rstate','var')
    error('RSTATE MUST EXIST IN WORKSPACE');
end

fname = 'data_peta_240215'; % file to write to
d = 0.01; % distance to move each time
T = 1; % dummy time interval to send commands in
N = 90; % number of poses
M = 500; % number of measurements per pose
thRef = -pi/2; % reference orientation
minDelTh = deg2rad(5); % min orientation error to correct for

enc = encHistory(rob);
lzr = laserHistory(rob);
pause(0.1);

localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',100));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate));
pause(1);

%%
V = d/T;
poseHistory = zeros(3,N);
v = struct('left',0,'right',0);
t_range_collection = struct('start',{},'end',{});

t1 = tic();
for i = 1:N
	if toc(t1) > 3*3600 % greater than 3 hours
		break;
	end
	if mod(i,25) == 0
		save(fname,'enc','lzr','t_range_collection','poseHistory','-v7.3');
	end
	% localization
	while true
		% peta sometimes blanks out
		ranges = rob.laser.data.ranges;
		if any(ranges)
			break;
		end
	end
	[refinerStats,pose] = refiner.refine(ranges,rstate.pose);
	rstate.reset(pose);
	poseHistory(:,i) = pose;
	pause(1);
	
	% set angular velocity
	delTh = thDiff(pose(3),thRef);
	if abs(delTh) > minDelTh
		w = delTh/T;
	else
		w = 0;
	end
	
	% advance robot
	[v.left,v.right] = robotModel.Vw2vlvr(V,w);
	moveRob(rob,v,T);
	pause(1);
	
	% collect measurements
	t_range_collection(i).start = lzr.tArray(end);
	fprintf('Measurements at pose %d \n', i);
	for j = 1:M
		pause(0.2);
	end
	t_range_collection(i).end = lzr.tArray(end);
	beep; beep; % alert grad student
end

save(fname,'enc','lzr','t_range_collection','poseHistory','-v7.3');
vizer.delete;
enc.stopListening();
lzr.stopListening();

