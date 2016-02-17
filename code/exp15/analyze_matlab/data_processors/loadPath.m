function desiredPath = loadPath(fname)
    fid = fopen(fname,'r');
    count = 1;
    line = fgetl(fid);
    while ischar(line)
        clear locVel;
        words = strsplit(line,',');
        x = str2double(words{1});
        y = str2double(words{2});
        pts(count,:) = [x y];
        speed(count) = str2double(words{3});
        yawRate(count) = str2double(words{4});
        count = count+1;
        line = fgetl(fid);
    end
    desiredPath.pts = pts;
    desiredPath.speed = speed;
    desiredPath.yawRate = yawRate;
end