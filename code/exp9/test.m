clearAll;
%%

VArray = [1 1 1 1];
wArray = [0 0 0 0];
tArray = [1 2 3 4];
startPose = [0 0 pi/4]';
finalPose = integrateVelocities(startPose,VArray,wArray,tArray);

%%
[vlArray,vrArray] = robotModel.Vw2vlvr(VArray,wArray);
J = getJacobianParamsToIntegratedPose(startPose,vlArray,vrArray,tArray,@wheelToBodyCommanded,[0 0],1e-3*[1 1]);