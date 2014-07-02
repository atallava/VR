clearAll

load full_predictor_means_only_mar27_1
load test_repeated_refinement
load roomLineMap

localizer = lineMapLocalizer(map.objects);
visualizer = vizRangesOnMap(struct('localizer',localizer));

inputStruct.muArray = trainMuArray;
inputStruct.regClass = @nonParametricRegressor;
inputStruct.kernelFn = @kernelBox;
inputStruct.kernelParams = struct('h',0.1);
lGeomReg = localGeomRegressor(inputStruct);

vec = [];
rangesOld = ranges0;
for i = 1:5
    rangesNew = lGeomReg.predict(rangesOld);
    vec(i) = norm(rangesNew-rangesOld);
    rangesOld = rangesNew;
end