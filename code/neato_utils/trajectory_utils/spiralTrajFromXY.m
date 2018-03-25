function traj = spiralTrajFromXY(tp,x,y)
    %SPIRALTRAJFROMXY Construct trajectory from x,y points.
    %
    % traj = SPIRALTRAJFROMXY(tp,x,y)
    %
    % tp   - trajPlanner object.
    % x    - Vector.
    % y    - Vector.
    %
    % traj - stitchedSpiral object.
    
    nX = length(x);
    nY = length(y);
    condn = (nX == nY);
    msg = sprintf('%s: length(x) = %d not equal to length(y) = %d.\n', ...
        mfilename,nX,nY);
    assert(condn,msg);
    
    % fit curve
    fitType = 'smoothingspline';
    f = fit(x,y,fitType);
    nPoints = length(x);
    waypoints = zeros(nPoints,3);
    waypoints(:,1) = x;
    waypoints(:,2) = feval(f,x);
    
    % compute yaw
    dx = 1e-3;
    xPlus = waypoints(:,1)+dx;
    xMinus = waypoints(:,1)-dx;
    yPlus = feval(f,xPlus);
    yMinus = feval(f,xMinus);
    waypoints(:,3) = atan2(yPlus-yMinus,xPlus-xMinus);
        
    % plan trajectory
    traj = tp.planWithWaypoints(waypoints');
end

