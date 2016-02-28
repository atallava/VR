function particles = initParticlesProbePattern(map,support,bBox,xyScale,thScale,pose)
    %INITPARTICLESPROBEPATTERN
    %
    % particles = INITPARTICLESPROBEPATTERN(map,support,bBox,xyScale,thScale,pose)
    %
    % map       - lineMap object.
    % support   - Vertex struct.
    % bBox      - Vertec struct.
    % xyScale   - Scalar.
    % thScale   - Scalar.
    % pose      - Length 3 vector.
    %
    % particles - Struct array with fields ('pose').
    
    dXy = [1 1 -1 -1;-1 1 1 -1].*xyScale;
    dTh = uniformSamplesInRange([-thScale*0.5; thScale*0.5],4)';
    dPose = [dXy; dTh];
    particlePoses = bsxfun(@plus,pose,dPose);
        
    for i = 1:size(particlePoses,2)
       particles(i).pose = particlePoses(:,i); 
    end
end