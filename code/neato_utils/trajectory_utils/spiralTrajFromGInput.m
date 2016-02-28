function traj = spiralTrajFromGInput(tp,hf)
    %SPIRALTRAJFROMGINPUT Construct trajectory from graphical input.
    %
    % traj = SPIRALTRAJFROMGINPUT(tp)
    % traj = SPIRALTRAJFROMGINPUT(tp,hf)
    %
    % tp   - trajPlanner object.
    % hf   - Figure handle. If none provided, empty plot created.
    %
    % traj - stitchedSpiral object.

    % empty plot if no figure specified
    if nargin < 2
        hf = figure;
        plot(1,1);
        xlim([0 10]);
        ylim([0 10]);
        axis equal;
    end
    % x,y from ginput
    [x,y] = ginput;
    
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
    
    % plot fit
    figure(hf);
    hold on;
    h1 = plot(waypoints(:,1),waypoints(:,2),'b');
    quiverScale = 0.3;
    h2 = quiver(waypoints(:,1),waypoints(:,2),cos(waypoints(:,3)),sin(waypoints(:,3)),...
        quiverScale,'b');
    
    % plot planned trajectory
    h3 = plot(traj.poseArray(1,:),traj.poseArray(2,:),'r');
    legend([h1 h3],{'fit','spiral traj'});
end