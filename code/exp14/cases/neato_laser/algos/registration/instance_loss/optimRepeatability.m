% 
nSeeds = 5;
nDraws = 5;

nParams = length(lb);
params0Set = zeros(nSeeds,length(lb));
paramsOptimSet = cell(1,nSeeds);
objOptimSet = zeros(nSeeds,nDraws);

clockLocal = tic();
for i = 1:nSeeds
    fprintf('Seed %d.\n',i);
    params0Set(i,:) = uniformSamplesInRange([lb; ub],1);
    paramsOptim = zeros(nDraws,length(lb));
    for j = 1:nDraws
        fprintf('Draw %d.\n',j);
        [paramsOptim(j,:),objOptimSet(i,j)] = ...
            patternsearch(fun,params0Set(i,:),[],[],[],[],lb,ub,[]);
    end
    paramsOptimSet{i} = paramsOptim;
end
fprintf('Computation time: %.2fs.\n',toc(clockLocal));