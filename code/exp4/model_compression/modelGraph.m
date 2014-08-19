%% form model graph edges

load full_predictor_mar27_5
load roomLineMap
p2r = poses2R(struct('envLineMap',map,'laser',dp.laser));
XTest = dp.poses(:,dp.testPoseIds)';
muTest = testPdfs.paramArray(:,1,:); muTest = squeeze(muTest);
rArray = p2r.transform(XTest); 
rArray = squeeze(rArray);

modelGraph = zeros(dp.laser.nPixels,dp.laser.nPixels);
warning('off');
t1 = tic();
for i = 1:(dp.laser.nPixels-1)
    fprintf('Pixel %d...\n',i);
    for j = (i+1):dp.laser.nPixels
        model1 = rsim.pxRegBundleArray(1).regressorArray{i};
        x1 = rArray(:,i); y1 = muTest(:,i);
        model2 = rsim.pxRegBundleArray(1).regressorArray{j};
        x2 = rArray(:,j); y2 = muTest(:,j);
        res = compareModels(model1,model2,x1,y1,x2,y2);
        switch res
            case 1
                modelGraph(j,i) = 1;
            case -1
                modelGraph(i,j) = 1;
            case 2
                % TODO: undirected edge.
            case 0
                % Do nothing.
        end
    end
end
warning('on')
fprintf('Computation took %fs.\n',toc(t1));