function savePath(x,y,speed,yawRate,pathFname)
    count = 1;
    fid = fopen(pathFname,'w');
    for i = 1:length(x)
        line = sprintf('%.4f,%.4f,%.4f,%.4f\n',...
            x(i),y(i),speed(i),yawRate(i));
        fprintf(fid,line);
    end
end