function [VArray,wArray] = wheelToBodyCommanded(vlArray,vrArray,params)
%WHEELTOBODYCOMMANDED Convert commanded wheel velocities to body velocities
% under error.
% 
% [VArray,wArray] = WHEELTOBODYCOMMANDED(vlArray,vrArray,params)
% 
% vlArray - Left wheel velocities.
% vrArray - Right wheel velocities
% params  - Array with values (delV,delW).
% 
% VArray  - Body linear velocity.
% wArray  - Body angular velocity.

[VArray,wArray] = robotModel.vlvr2Vw(vlArray,vrArray);
VArray = VArray+VArray.*params(1);
wArray = wArray+params(2)*ones(size(wArray));
end