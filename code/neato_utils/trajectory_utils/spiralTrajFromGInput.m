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
    
    traj = spiralTrajFromXY(tp,x,y);
    
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