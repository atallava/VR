clearAll;
load test_optimization_data
objective = localGeomObjective(struct('ranges',patch,'bearings',patchBearings,'alpha',0.1));

problem.objective = @objective.value;
problem.Aineq = []; problem.bineq = [];
problem.Aeq = []; problem.beq = [];
problem.lb = -0.1*patch; problem.ub = 0.1*patch;
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.x0 = zeros(size(patch));
problem.options = optimoptions('fmincon','Display','iter','Algorithm','interior-point');

dr = fmincon(problem);
