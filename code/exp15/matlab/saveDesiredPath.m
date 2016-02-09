function saveDesiredPath(pathStt,pathFname)
    count = 1;
    fid = fopen(pathFname,'w');
    for i = 1:length(pathStt)
        line = sprintf('%.4f,%.4f,%.4f,%.4f\n',...
            pathStt(i).x,pathStt(i).y,pathStt(i).speed,pathStt(i).yawRate);
        fprintf(fid,line);
    end
end