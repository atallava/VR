function adesPathStt = spiralTrajToAdesPath(traj)
    % traj - stitchedSpiral object
    
    % ades path struct
    adesPathStt = struct('x',{},'y',{},'speed',{},'yawRate',{});
    count = 1;
    
    % first pose
    adesPathStt(count).x = traj.poseArray(1,1);
    adesPathStt(count).y = traj.poseArray(2,1);
    adesPathStt(count).speed = traj.VArray(1);
    adesPathStt(count).yawRate = traj.wArray(1);
    
    currentAdesPathXy = [adesPathStt(count).x adesPathStt(count).y];
    nPoses = size(traj.poseArray,2);
    minPathResn = 0.1;
    for i = 1:nPoses
        currentSpiralTrajXy = [traj.poseArray(1,i) traj.poseArray(2,i)];
        ds = norm(currentAdesPathXy-currentSpiralTrajXy);
        if ds < minPathResn
            continue;
        else
            count = count+1;
            adesPathStt(count).x = traj.poseArray(1,i);
            adesPathStt(count).y = traj.poseArray(2,i);
            adesPathStt(count).speed = traj.VArray(i);
            adesPathStt(count).yawRate = traj.wArray(i);
            currentAdesPathXy = [adesPathStt(count).x adesPathStt(count).y];
        end
    end
end