function hf = plotDesiredAndFollowedPaths(desiredPath,vehicleStateLog)
    x = desiredPath.pts(:,1);
    y = desiredPath.pts(:,2);
    hf = figure;
    h1 = plot(x,y,'b');
    axis equal;
    hold on;
   
    x = vehicleStateLog(:,1);
    y = vehicleStateLog(:,2);
    yaw = vehicleStateLog(:,3);
    h2 = plot(x,y,'r');
    quiverScale = 0.01;
    quiver(x,y,quiverScale*cos(yaw),quiverScale*sin(yaw),'r','autoscale','off');
    xlabel('x');
    ylabel('y');
    
    legend([h1 h2],{'desired path','followed path'});
end