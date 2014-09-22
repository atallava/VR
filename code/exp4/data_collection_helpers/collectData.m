% collectData using keyboard inputs, drive around robot and collect ranges

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

v = struct('left',0,'right',0);
T = [1 -0.5*robotModel.W; ...
    1 0.5*robotModel.W];
data_count = 0;
num_obs = 30;
t_range_collection = struct('start',{},'end',{});

t_sys_start = tic;
enc = encHistory(rob);
lzr = laserHistory(rob);
%lzr.togglePlot();
pause(0.1);

localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',100));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate));
pause(1);
poseHistory = [];

while true
    comm = input('enter command: ', 's');
    switch comm
        % all motions open-loop but don't care
        case 'f'
            % move forward
            v.left = 0.2; v.right = 0.2;
            moveRob(rob, v, 2);
        case 'sf'
            % short move forward
            v.left = 0.2; v.right = 0.2;
            moveRob(rob, v, 1);
        case 'ff'
            % longer move forward
            v.left = 0.2; v.right = 0.2;
            moveRob(rob, v, 4);
        case 'b'
            % move bwd
            v.left = -0.2; v.right = -0.2;
            moveRob(rob, v, 2);
        case 'cw'
            % rotate cw
            v.left = 0.05; v.right = -0.05;
            moveRob(rob, v, 2);
        case 'ccw'
            % rotate ccw
            v.left = -0.05; v.right = 0.05;
            moveRob(rob, v, 2);
        case 'lf'
            % move along left arc
            V = 0.2; w = deg2rad(20);
            vel = T*[V; w];
            v.left = vel(1); v.right = vel(2);
            moveRob(rob, v, 2);
        case 'llf'
            % sharper turn along left arc
            V = 0.1; w = deg2rad(20);
            vel = T*[V; w];
            v.left = vel(1); v.right = vel(2);
            moveRob(rob, v, 4);
        case 'rf'
            % move along right arc
            V = 0.2; w = -deg2rad(20);
            vel = T*[V; w];
            v.left = vel(1); v.right = vel(2);
            moveRob(rob, v, 2);
        case 'rrf'
            % sharper turn along right arc
            V = 0.1; w = -deg2rad(20);
            vel = T*[V; w];
            v.left = vel(1); v.right = vel(2);
            moveRob(rob, v, 4);
        case 'pose'
            % refine pose
            happy = false;
            while ~happy
                ranges = rob.laser.data.ranges;
                [refinerStats,pose] = refiner.refine(ranges,rstate.pose); 
                rstate.reset(pose);
                happy = input('Happy? (1/0): ');
            end
        case 'rec'
            % take down data
            pause(0.1);
            data_count = data_count+1;
            poseHistory(:,data_count) = rstate.pose;
            t_range_collection(data_count).start = lzr.tArray(end);
            fprintf('Collecting data set %d \n', data_count);
            for i = 1:num_obs
                pause(0.2);
            end
            t_range_collection(data_count).end = lzr.tArray(end);
            beep; beep; % alert grad student
            fprintf('Observations taken. Continue moving around. \n');
            pause(0.1);
		case 'save'
			% write data to file
			fname = input('file to write to: ', 's');
			save(fname,'enc','lzr','t_range_collection','poseHistory','-v7.3');
			fprintf('Saved to file. Continue moving around. \n');
        case 'x'
            pause(0.1);
            % exit
            break
        otherwise
            fprintf('invalid input\n');
    end
end

vizer.delete;
enc.stopListening();
lzr.stopListening();
