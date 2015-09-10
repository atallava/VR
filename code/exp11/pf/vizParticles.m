function vizParticles(map,particles,refPose)
    %VIZPARTICLES
    %
    % hf = VIZPARTICLES(map,particles,refPose)
    %
    % map       - lineMap instance.
    % particles - Struct of particles.
    % refPose   - Reference refPose, optional input.
        
    map.plot();
    hold on;
    poses = [particles.pose];
    scatter(poses(1,:),poses(2,:),15,'r','filled');
    if nargin > 2
        hq = quiver(refPose(1),refPose(2),0.4*cos(refPose(3)),0.4*sin(refPose(3)),'k','LineWidth',2); hold off;
        adjust_quiver_arrowhead_size(hq,4);
    end
end