function [x,y] = pruneFinePathPts(xFine,yFine,resn)
    %PRUNEFINEPATHPTS
    %
    % [x,y] = PRUNEFINEPATHPTS(xFine,yFine,resn)
    %
    % xFine -
    % yFine -
    % resn  -
    %
    % x     -
    % y     -

    count = 1;
    x(count) = xFine(1);
    y(count) = yFine(1);
    
    nPts = length(xFine);
    for i = 1:nPts
        ds = norm([xFine(i)-x(count) yFine(i)-y(count)]);
        if ds < resn
            continue;
        else
            count = count+1;
            x(count) = xFine(i);
            y(count) = yFine(i);
        end
    end 
end