function hf = plotDesiredAndFollowedPaths(desiredPath,vehicleStateLog)
    x = [desiredPath.x];
    y = [desiredPath.y];
    hf = figure;
    h1 = plot(x,y,'b');
    axis equal;
    hold on;
   
    x = [vehicleStateLog.x];
    y = [vehicleStateLog.y];
    yaw = [vehicleStateLog.yaw];
    h2 = plot(x,y,'r');
    quiverScale = 0.01;
    quiver(x,y,quiverScale*cos(yaw),quiverScale*sin(yaw),'r','autoscale','off');
    xlabel('x');
    ylabel('y');
    
    legend([h1 h2],{'desired path','followed path'});
end