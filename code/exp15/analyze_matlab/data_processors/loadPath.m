function desiredPath = loadPath(fname)
    fid = fopen(fname,'r');
    count = 1;
    line = fgetl(fid);
    while ischar(line)
        clear locVel;
        words = strsplit(line,',');
        locVel.x = str2double(words{1});
        locVel.y = str2double(words{2});
        locVel.speed = str2double(words{3});
        locVel.yawRate = str2double(words{4});
        desiredPath(count) = locVel;
        count = count+1;
        line = fgetl(fid);
    end
end