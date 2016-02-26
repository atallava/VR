function outStruct = runParticleFilter(inputStruct)
    % unpack variables
    if isfield(inputStruct,'fnameReadings')
        fnameReadings = inputStruct.fnameReadings;
    else
        error('fnameReadings not a field in inputStruct.');
    end
    if isfield(inputStruct,'debugFlag')
        debugFlag = inputStruct.debugFlag;
    else
        debugFlag = 0;
    end
    if isfield(inputStruct,'initDistParams')
        initDistParams = inputStruct.initDistParams;
    else
        error('initDistParams not a field in inputStruct.');
    end
    if isfield(inputStruct,'motionModelParams')
        motionModelParams = inputStruct.motionModelParams;
    else
        error('motionModelParams not a field in inputStruct.');
    end
    if isfield(inputStruct,'obsModelParams')
        obsModelParams = inputStruct.obsModelParams;
    else
        error('obsModelParams not a field in inputStruct.');
    end
    if isfield(inputStruct,'resamplerParams')
        resamplerParams = inputStruct.resamplerParams;
    else
        error('resamplerParams not a field in inputStruct.');
    end
    if isfield(inputStruct,'vizFlag')
        vizFlag = inputStruct.vizFlag;
    else
        vizFlag = 0;
    end
    if isfield(inputStruct,'saveRes')
        saveRes = inputStruct.saveRes;
    else
        saveRes = 0;
    end
    if saveRes == 1
        if isfield(inputStruct,'fnameRes')
            fnameRes = inputStruct.fnameRes;
        else
            error('fnameRes not a field in inputStruct.');
        end
    end
    
    % unpack initial distribution parameters
    if isfield(initDistParams,'xyScale')
        xyScale = initDistParams.xyScale;
    else
        error('xyScale not a field in initDistParams.');
    end
    if isfield(initDistParams,'thScale')
        thScale = initDistParams.thScale;
    else
        error('thScale not a field in initDistParams.');
    end
    if isfield(initDistParams,'robotBBox')
        robotBBox = initDistParams.robotBBox;
    else
        error('robotBBox not a field in initDistParams.');
    end
    if isfield(initDistParams,'initDistSampler')
        initDistSampler = initDistParams.initDistSampler;
    else
        error('initDistSampler not a field in initDistParams.');
    end
    if isfield(initDistParams,'PMax')
        PMax = initDistParams.PMax;
    else
        error('PMax not a field in initDistParams.');
    end
    
    % unpack motion model parameters
    if isfield(motionModelParams,'etaV')
        etaV = motionModelParams.etaV;
    else
        error('etaV not a field in motionModelParams.');
    end
    if isfield(motionModelParams,'etaW')
        etaW = motionModelParams.etaW;
    else
        error('etaW not a field in motionModelParams.');
    end
    
    % unpack observation model parameters
    if isfield(obsModelParams,'obsModel')
        obsModel = obsModelParams.obsModel;
    else
        error('obsModel not a field in obsModelParams.');
    end
    if isfield(obsModelParams,'powerScale')
        powerScale = obsModelParams.powerScale;
    else
        error('powerScale not a field in obsModelParams.');
    end
    if isfield(obsModelParams,'bearingSkip')
        bearingSkip = obsModelParams.bearingSkip;
    else
        error('bearingSkip not a field in obsModelParams.');
    end
    
    % unpack resampler parameters
    if isfield(resamplerParams,'resampler')
        resampler = resamplerParams.resampler;
    else
        error('resampler not a field in resamplerParams.');
    end
    
    % load readings
    load(fnameReadings, ...
        'map','poseHistory','readings','sensor','support','tHistory','traj');
    
    if debugFlag
        fprintf('Readings file: %s\n\n',fnameReadings);
                
        fprintf('Initial distribution parameters:\n');
        fprintf(['xyScale: %.4f\n' ...
            'thScale: %.4f\n' ...
            'initDistSampler: %s\n' ...
            'PMax: %d\n\n'], ...
            xyScale,thScale,func2str(initDistSampler),PMax);
        
        fprintf('Motion model parameters:\n');
        fprintf(['etaV: %.4f\n' ....
            'etaW: %.4f\n\n'], ...
            etaV,etaW);
        
        fprintf('Observation model parameters:\n');
        fprintf(['model: %s\n' ...
            'powerScale: %.4f\n' ...
            'bearing skip: %d\n\n'], ...
            func2str(obsModel),powerScale,bearingSkip);
        
        fprintf('Resampling parameters:\n');
        fprintf(['resampler: %s\n\n'], ...
            func2str(resampler));
        
        if saveRes
            fprintf('Results file: %s\n',fnameRes);
        end
    end
    
    % sample particles from initial distribution
    particles = initDistSampler(map,support,robotBBox,xyScale,thScale);
    
    % retain PMax particles
    if length(particles) > PMax
        ids = randsample(1:length(particles),PMax);
        particles = particles(ids);
    end
    P = length(particles);

    % process readings
    L = length(readings);
    
    % logs
    particlesLog = cell(1,L+1);
    particlesLog{1} = particles;
    weightsLog = cell(1,L);
    
    clockLocal = tic();
    for i = 1:L
        data = readings(i).data;
        if strcmp(readings(i).type,'motion')
            % motion update
            particles = motionUpdate(particles,data.VArray,data.wArray,data.dtArray,etaV,etaW);
            particles = pruneInvalidPoses(particles,map,support,robotBBox);
        else
            % observation update
            % subsample ranges
            ranges = data.ranges;
            bearings = sensor.bearings;
            [ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);
            
            % get weights from sensor model
            weights = obsModel(map,sensor,ranges,bearings,particles);
            weights = powerScaleWeights(weights,powerScale);
            
            % resample
            particles = resampler(particles,weights);
        end
        if vizFlag
            vizParticles(map,particles,weights);
            title(sprintf('i: %d',i));
            pause(1);
            close all;
        end
        particlesLog{i+1} = particles;
        weightsLog{i} = weights;
    end
    fprintf('Computation took %.2fs.\n',toc(clockLocal));
    
    outStruct.particlesLog = particlesLog;
    outStruct.weightsLog = weightsLog;
    
    % save
    if saveRes
        % save everything
        save(fnameRes);
    end
end