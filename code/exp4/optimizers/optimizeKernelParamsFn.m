function params = optimizeKernelParamsFn(err)
warning('off');
problem.objective = @(x) err.value(struct('h',x(1),'lambda',x(2)));
problem.x0 = [1 1];
problem.Aineq = []; problem.bineq = [];
problem.Aeq = []; problem.beq = [];
problem.lb = zeros(size(problem.x0)); problem.ub = Inf(size(problem.x0));
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon','Algorithm','interior-point','Display','off');
params = fmincon(problem);
warning('on');
end

