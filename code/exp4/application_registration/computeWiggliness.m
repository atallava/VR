clearAll
load nsh3_corridor
load processed_data_sep14
load params
s = load('sim_sep6_1');
b = load('sim_baseline');

poseId = 6;
pose0 = poses(:,poseId);
perturbations = generatePerturbations([-0.2 0.2;-0.2 0.2; deg2rad([-20 20])],20); 
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));

%%
t1 = tic();
fprintf('Real...\n');
scansReal = rangesFromObsArray(obsArray,poseId,1:numScans);
resReal = getWiggliness(scansReal,pose0,map,perturbations);

fprintf('Sim...\n');
scansSim = generateScansAtState(s.rsim,pose0,map,numScans);
resSim = getWiggliness(scansSim,pose0,map,perturbations);

fprintf('Baseline...\n');
scansBaseline = generateScansAtState(b.rsim,pose0,map,numScans);
resBaseline = getWiggliness(scansBaseline,pose0,map,perturbations);
fprintf('Computation took %.2fs.\n',toc(t1));

save('wiggliness_results','resReal','resSim','resBaseline');

%%
pEstReal = [resReal.pEst];
pEstSim = [resSim.pEst];
pEstBaseline = [resBaseline.pEst];
figure; h1 = scatter3(pEstReal(1,:),pEstReal(3,:),pEstReal(3,:)); 
xlabel('x'); ylabel('y'); zlabel('th'); title('real');
figure; h2 = scatter3(pEstSim(1,:),pEstSim(3,:),pEstSim(3,:));
xlabel('x'); ylabel('y'); zlabel('th'); title('sim');
figure; h3 = scatter3(pEstBaseline(1,:),pEstBaseline(3,:),pEstBaseline(3,:));
xlabel('x'); ylabel('y'); zlabel('th'); title('baseline');
