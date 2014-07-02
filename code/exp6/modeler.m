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
inputStruct.numNbrs = 2;
inputStruct.kernelFn = @kernelRBF;
inputStruct.kernelParams = struct('h',0.1/3);
lGeomReg1 = localGeomRegressor(inputStruct);
inputStruct.numNbrs = 6;
%inputStruct.kernelFn = @kernelBox;
%inputStruct.kernelParams = struct('h',0.2);
lGeomReg2 = localGeomRegressor(inputStruct);

%%
rsim.setMap(map);
errSim = []; err11 = []; err12 = [];
for i = 13%:length(dp.testPoseIds)
    disp(i);
    id = dp.testPoseIds(i);
    p = dp.poses(:,id);
    rangesSim = rsim.simulate(p);
    rangesGeom = rsim.simulateGeometric(p);
    ranges11 = lGeomReg1.predict(rangesSim);
    ranges12 = lGeomReg2.predict(rangesSim);
    rr = testMuArray(i,:); outIds = rr > 4.5;
    vec = rangesSim-rr; 
    vec(outIds) = []; vec(isnan(vec)) = [];
    errSim(i) = mean(vec);
    vec = ranges11-rr;
    vec(outIds) = []; vec(isnan(vec)) = [];
    err11(i) = mean(vec);
    vec = ranges12-rr;
    vec(outIds) = []; vec(isnan(vec)) = [];
    err12(i) = mean(vec);
end
