function hf = vizParticles(map,particles,weights)
    %VIZPARTICLES Visualize particles on map.
    %
    % hf = VIZPARTICLES(map,particles)
    %
    % map       - lineMap instance.
    % particles - Struct of particles.
            
    hf = map.plot();
    hold on;
    poses = [particles.pose];
    % particle poses
    scatter(poses(1,:),poses(2,:),15,'r','filled');
    
    % quiver most likely pose
    [~,mleId] = max(weights);
    refPose = particles(mleId).pose;
    quiverScale = 0.4;
    hq = quiver(refPose(1),refPose(2),quiverScale*cos(refPose(3)),quiverScale*sin(refPose(3)),...
        'k','LineWidth',2,'autoscale','off');
    
    hold off;
end