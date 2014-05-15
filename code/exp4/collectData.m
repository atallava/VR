%collectData using keyboard inputs, drive around robot and collect ranges
% laser must be on

if ~isfield(rob.laser.data,'header')
    error('LASER MUST BE ON!');
end

v = struct('left',0,'right',0);
W = 0.235;
T = [1 -0.5*W; ...
    1 0.5*W];
data_count = 0;
num_obs = 300;
t_range_collection = struct('start',{},'end',{});

t_sys_start = tic;
enc = encHistory(rob);
lzr = laserHistory(rob);
pause(0.1);

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
        case 'rec'
            % take down data
            pause(0.1);
            data_count = data_count+1;
            t_range_collection(data_count).start = lzr.tArray(end);
            fprintf('Collecting data set %d \n', data_count);
            for i = 1:num_obs
                pause(0.3);
            end
            t_range_collection(data_count).end = lzr.tArray(end);
            beep; beep; % alert grad student
            fprintf('Observations taken. Continue moving around. \n');
            pause(0.1);
        case 'x'
            pause(0.1);
            % exit
            break
        otherwise
            fprintf('invalid input\n');
    end
end

enc.stopListening();
lzr.stopListening();





