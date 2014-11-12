function J = getJacobianParamsToIntegratedPose(startPose,vlArray,vrArray,tArray,wheelToBodyVel,params,delParams)
%GETJACOBIANPARAMSTOINTEGRATEDPOSE 
% 
% J = GETJACOBIANPARAMSTOINTEGRATEDPOSE(startPose,vlArray,vrArray,tArray,wheelToBodyVel,params,delParams)
% 
% startPose      - Array of size 3.
% vlArray        - Left wheel velocities.
% vrArray        - Right wheel velocities.
% tArray         - Timestamps.
% wheelToBodyVel - Handle to function that maps wheel to body velocities.
% params         - Array of params.
% delParams      - Change to each params in getting Jacobian.
% 
% J              - Jacobian, array of size 3 x num params.

nParams = length(params);
J = zeros(3,nParams);

for i = 1:nParams
    paramsPlus = params;
    paramsPlus(i) = paramsPlus(i)+delParams(i);
    [VArray,wArray] = wheelToBodyVel(vlArray,vrArray,paramsPlus);
    finalPlus = integrateVelocities(startPose,VArray,wArray,tArray);
    
    paramsMinus = params;
    paramsMinus(i) = paramsMinus(i)-delParams(i);
    [VArray,wArray] = wheelToBodyVel(vlArray,vrArray,paramsMinus);
    finalMinus = integrateVelocities(startPose,VArray,wArray,tArray);
    
    delPose = pose2D.poseDiff(finalMinus,finalPlus);
    J(:,i) = delPose./(2*delParams(i));
end

end
