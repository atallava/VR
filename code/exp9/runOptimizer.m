load sim_run
inputStruct.data = dataCommVel;
inputStruct.wheelToBodyVel = @wheelToBodyCommanded;
inputStruct.params0 = [0.2 0.2]';
inputStruct.delParams = [0.01 0.01]';
op = optimizeParamsToIntegratedPose(inputStruct);
params = op.refineParams();