% neighbour-effect modeler

%% initialize
clearAll
%load simulated_means_mar27
load full_predictor_means_only_mar27_2
load poses_after_icp_mar27
load roomLineMap

localizer = lineMapLocalizer(map.objects);
visualizer = vizRangesOnMap(struct('localizer',localizer));

inputStruct.muArray = trainMuArray;
inputStruct.regClass = @nonParametricRegressor;
inputStruct.kernelFn = @kernelBox;
inputStruct.kernelParams = struct('h',0.1);
lGeomReg = localGeomRegressor(inputStruct);

%%
rsim.setMap(map);
err0 = []; err1 = [];
for i = 13%:length(dp.testPoseIds)
    disp(i);
    id = dp.testPoseIds(i);
    p = dp.poses(:,id);
    ranges0 = rsim.simulate(p);
    rangesGeom = rsim.simulateGeometric(p);
    ranges1 = lGeomReg.predict(ranges0);
    ranges1 = lGeomReg.predict(ranges1);
    rr = testMuArray(i,:); outIds = rr > 4.5;
    vec = ranges0-rr; 
    vec(outIds) = []; vec(isnan(vec)) = [];
    err0(i) = mean(vec);
    vec = ranges1-rr;
    vec(outIds) = []; vec(isnan(vec)) = [];
    err1(i) = mean(vec);
end
