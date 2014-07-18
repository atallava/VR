clearAll;
objective = timingObjective(struct());
problem.fitnessfcn = @(x) objective.value(x(1),x(2),x(3));
problem.nvars = 3;
problem.Aineq = [objective.tEnc -objective.tLaser 0; ...
    0 0 -1];
problem.Bineq = [0; 0];
problem.Aeq = []; problem.Beq = [];
problem.lb = [1 1 0]; problem.ub = [10 5 5];
problem.nonlcon = []; problem.IntCon = [1 2];
problem.options = gaoptimset('Display','iter');
%[x,fval] = ga(@(x) objective.value(x(1),x(2),x(3)),3,A,b,[],[],lb,ub,[],IntCon,options);
[x,fval] = ga(problem);