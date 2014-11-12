clearAll
%%
load sim_run
inputStruct.data = dataCommVel;
inputStruct.wheelToBodyVel = @wheelToBodyCommanded;
inputStruct.params0 = [0.02 0.02]';
inputStruct.delParams = [0.0011 0.001]';
op = optimizeParamsToIntegratedPose(inputStruct);
params = op.refineParams();