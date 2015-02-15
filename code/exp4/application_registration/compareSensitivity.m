clearAll
load processed_data_sep25_disp
b = load('sim_baseline');
s = load('sim_sep6_1');
load('nsh3_corridor','map')
load('params','numScans')
load perturbations

%% 
nPoses = size(obsArray,1);
for i = 1:nPoses
    poseRef = pose0+i*displacement;
    scans = rangesFromObsArray(obsArray,i,1:numScans);
    stat(i).real = scanErrorStatistic(poseRef,scans,map,perturbations);
    scans = generateScansAtState(s.rsim,poseRef,map,numScans);
    stat(i).sim = scanErrorStatistic(poseRef,scans,map,perturbations);
    scans = generateScansAtState(b.rsim,poseRef,map,numScans);
    stat(i).baseline = scanErrorStatistic(poseRef,scans,map,perturbations);
end