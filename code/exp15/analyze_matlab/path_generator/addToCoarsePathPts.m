function [x,y] = addToCoarsePathPts(xCoarse,yCoarse,resn)
    x = [];
    y = [];
    for i = 1:length(xCoarse)-1
        ds = norm([xCoarse(i+1)-xCoarse(i) yCoarse(i+1)-yCoarse(i)]);
        if ds > resn
            th = atan2(yCoarse(i+1)-yCoarse(i),xCoarse(i+1)-xCoarse(i));
            vec = [1:floor(ds/resn)].*resn;
            xAdd = xCoarse(i)+vec.*cos(th);
            yAdd = yCoarse(i)+vec.*sin(th);
            x = [x xCoarse(i) xAdd];
            y = [y yCoarse(i) yAdd];
        else
            x = [x xCoarse(i)];
            y = [y yCoarse(i)];
        end
    end
    x = [x xCoarse(end)];
    y = [y yCoarse(end)];
end