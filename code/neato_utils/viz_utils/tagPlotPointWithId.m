function txt = tagPlotPointWithId(obj,eventObj,x,y)
    %TAGPLOTPOINTWITHID Function for use with datacursormode.
    % Work for 2d plots only.
    %
    % txt = TAGPLOTPOINTWITHID(obj,eventObj,x,y)
    %
    % eventObj - 
    % x        - Vector of x-data. 
    % y        - Vector of y-data.
    %
    % txt      - 
    
    pos = get(eventObj,'Position');
    xCoord = pos(1); yCoord = pos(2);
    xId = find(x == xCoord);
    yId = find(y == yCoord);
    id = intersect(xId,yId);
    txt = {['x: ',num2str(xCoord)],...
        ['y: ',num2str(yCoord)],...
        ['id: ',num2str(id)]};
end