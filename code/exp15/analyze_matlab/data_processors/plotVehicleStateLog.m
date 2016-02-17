function hf = plotVehicleStateLog(vehicleStateLog)
    x = [vehicleStateLog.x];
    y = [vehicleStateLog.y];
    yaw = [vehicleStateLog.yaw];
    hf= figure;
    plot(x,y);
    quiverScale = 0.01;
    quiver(x,y,quiverScale*cos(yaw),quiverScale*sin(yaw),'autoscale','off');
    xlabel('x');
    ylabel('y');
    axis equal
end