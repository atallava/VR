% collect scans from neato 
% for transformation between markers and robot frame

% poseIn should be here

% initialize
cond = logical(exist('rob','var'));
assert(cond,('ROB MUST EXIST IN WORKSPACE'));
cond = isfield(rob.laser.data,'header');
assert(cond,'LASER MUST BE ON!');

load('tfcalib_map','map'); % opti-L as map
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',100));


%%
numScans = 10;
ranges = zeros(numScans,360);
poseIn = [0; 0; 0]; % manual input
rstate.reset(poseIn);
poses = zeros(3,numScans);

for i = 1:numScans
	ranges(i,:) = rob.laser.data.ranges;
	happy = 0;
	while ~happy
		[refinerStats,poseIn] = refiner.refine(ranges,rstate.pose); 
		rstate.reset(poseIn);
		happy = input('Happy? (1/0): ');
	end
	poses(:,i) = rstate.pose;
	pause(0.5); % for scan to refresh
end

%%
robotName = 'peta';
tag = 'tfcalib';
dateStr = yymmddDate();
index = '1';
fname = buildDataFileName(robotName,tag,dateStr,index);
save(fname,'ranges','poses');

