clearAll;
load sim_run
data = dataCommVel(1);
%%
data.startPose = [0; 0; 0];
data.vlArray = ones(1,100);
data.vrArray = ones(1,100);
data.tArray = [1:100]*0.1;

%%
J = getJacobianParamsToIntegratedPose(data.startPose,data.vlArray,data.vrArray,data.tArray,@wheelToBodyCommanded,[0.01 0.01]',[0.001 0.001]');