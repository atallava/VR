function [VArray,wArray] = wheelToBodyEnc(vlArray,vrArray,params)
%WHEELTOBODYENC Convert wheel to body velocities under encoder error.
% 
% [VArray,wArray] = WHEELTOBODYENC(vlArray,vrArray,params)
% 
% vlArray - Left wheel velocities.
% vrArray - Right wheel velocities
% params  - Array with values (delVl,delVr)
% 
% VArray  - Body linear velocity.
% wArray  - Body angular velocity.

vlArray = vlArray+params(1)*vlArray;
vrArray = vrArray+params(2)*vrArray;
[VArray,wArray] = robotModel.vlvr2Vw(vlArray,vrArray);
end