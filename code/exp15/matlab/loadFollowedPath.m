function outStt = loadFollowedPath(fname)
    outStt = struct('x',{},'y',{},'yaw',{},'t',{});
    count = 1;
    fid = fopen(fname,'r');
    line = fgetl(fid);
    while ischar(line)
        c = strsplit(line,',');
        outStt(count).x = str2double(c{1});
        outStt(count).y = str2double(c{2});
        outStt(count).yaw = str2double(c{3});
        outStt(count).t = str2double(c{4});
        count = count+1;
        line = fgetl(fid);
    end
end