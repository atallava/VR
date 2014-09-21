function res = computeAlgoDifference(rsim,poseRef,scansReal,map)
load('perturbations','perturbations');
load('params','numScans');

% Measured difference
outReal = scanErrorStatistic(poseRef,scansReal,map,perturbations);
res.TReal = outReal.poseError;
scansSim = generateScansAtState(rsim,poseRef,map,numScans);
outSim = scanErrorStatistic(poseRef,scansSim,map,perturbations);
res.TSim = outSim.poseError;
res.dTMeasured = abs(res.TSim-res.TReal);

% Sim sensitivity
res.dTSimSensivity = computeSimSensitivity(rsim,poseRef,map);

% Upper bound
res.dTUpper = res.dTMeasured+res.dTSimSensitivity;
end