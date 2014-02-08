function data = startExp(rob)
% assumes laser is on

v = struct('left',0,'right',0);
W = 0.235;
T = [1 -0.5*W; ...
    1 0.5*W];
data = struct('u',{},'z',{});
data_count = 1;

num_obs = 10;
ranges = zeros(360,num_obs);

enc = encHistory(rob);
pause(0.1);

while true
    comm = input('enter command: ', 's');
    switch comm
        % all motions open-loop but don't care
        case 'f'
            % move forward
            v.left = 0.2; v.right = 0.2;
            moveRob(rob, v, 2);
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
            data(data_count).u = enc.encArray;
            for i = 1:num_obs
                ranges(:,i) = rob.laser.data.ranges;
                pause(0.3);
            end
            data(data_count).z = ranges;
            data_count = data_count + 1;            
            fprintf('Observations taken. Continue moving around. \n');
            enc.Reset();
            pause(0.1);
        case 'x'
            % exit
            break
        otherwise
            fprintf('invalid input\n');
    end
end
    
end

function moveRob(rob, v, T)
% send rob velocities v for time T

t1 = tic;
while toc(t1) < T
    rob.sendVelocity(v.left, v.right);
    pause(0.001);
end
rob.sendVelocity(0, 0);
end




