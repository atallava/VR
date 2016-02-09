function genStraightLinePath()
    pathFileName = '../data/straight_line_path_1.txt';
    fid = fopen(pathFileName,'w');
    dt = 0.05;
    duration = 20;
    speed = 0.5;
    yawRate = 0.0;
    t = 0.0;
    x = 0.0;
    y = 0.0;
    while t < duration
        ds = speed*dt;
        condn = ds >= 0.01;
        if ~condn
            error('Resolution has to be greater than 0.01');
        end
        x = x+speed*dt;
        line = sprintf('%.3f,%.3f,%.3f,%.3f\n',x,y,speed,yawRate);
        fprintf(fid,line);
        t = t+dt;
    end
end