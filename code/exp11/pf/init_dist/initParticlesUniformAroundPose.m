function particles = initParticlesUniformAroundPose(map,support,bBox,xyScale,thScale,pose)
    %INITPARTICLESUNIFORMAROUNDPOSE
    %
    % particles = INITPARTICLESUNIFORMAROUNDPOSE(map,support,bBox,xyScale,thScale,pose)
    %
    % map       - lineMap object.
    % support   - Vertex struct.
    % bBox      - Vertec struct.
    % xyScale   - Scalar.
    % thScale   - Scalar.
    % pose      - Length 3 vector.
    %
    % particles - Struct array with fields ('pose').
    
    nSamples = 100;
    dXyLims = [-0.5*xyScale -0.5*xyScale; ...
        0.5*xyScale 0.5*xyScale];
    dXy = uniformSamplesInRange(dXyLims,nSamples);
    dThLims = [-thScale*0.5; thScale*0.5];
    dTh = uniformSamplesInRange(dThLims,nSamples);
    dPose = [dXy'; dTh'];
    particlePoses = bsxfun(@plus,dPose,pose);

    for i = 1:nSamples
        particles(i).pose = particlePoses(:,i);
    end
end