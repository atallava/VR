clearAll
load test_full_scan_smoothing
localizer = lineMapLocalizer(map.objects);
matcher = localMatch(struct('localizer',localizer,'map',map,'maxInClusterLength',20,'minInClusterLength',10));
vizer = vizRangesOnMap(struct('localizer',localizer));
outIds = matcher.getOutIds(ranges,pose);
inClusters = matcher.getInClusters(outIds);

problem.Aineq = []; problem.bineq = [];
problem.Aeq = []; problem.beq = [];
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon','Algorithm','interior-point','Maxiter',20);

smoothedRanges = ranges;
t1 = tic();
for i = 1:length(inClusters)
    fprintf('Cluster %d...\n',i)
    section = inClusters(i).members;
    patch = ranges(section);
    patchBearings = bearings(section);
    objective = localGeomObjective(struct('ranges',patch,'bearings',patchBearings,'alpha',0.1));
    if length(section) < objective.localGeomExtent
        continue
    end
    
    problem.objective = @objective.value;
    problem.lb = -objective.maxTweakFraction*patch; 
    problem.ub = objective.maxTweakFraction*patch;
    problem.x0 = zeros(size(patch));
    dr = fmincon(problem);
    smoothedRanges(section) = patch+dr;
end
fprintf('Finished.\n');
fprintf('Computation took %f s.\n',toc(t1));

