% find slip parameters
clearAll
load sim_data

%% commanded velocities
inputStruct.data = dataCommVel;
inputStruct.wheelToBodyVel = @wheelToBodyCommanded;
inputStruct.params0 = [0.0 0.0]';
inputStruct.delParams = [0.0011 0.001]';
op = optimizeParamsToIntegratedPose(inputStruct);
params = op.refineParams();

%% encoder velocities
inputStruct.data = dataEncVel;
inputStruct.wheelToBodyVel = @wheelToBodyEnc;
inputStruct.params0 = [0.0 0.0]';
inputStruct.delParams = [0.0011 0.001]';
op = optimizeParamsToIntegratedPose(inputStruct);
params = op.refineParams();

