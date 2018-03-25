function [vlArray,vrArray,tArray] = encHist2vlvrArray(enc,tfl)
%ENCHIST2VARRAY 
% 
% [vlArray,vrArray] = ENCHIST2VARRAY(enc,tfl)
% 
% enc     - encHistory object.
% tfl     - trajectoryFollower object.
% 
% vlArray - Left wheel velocity array.
% vrArray - Right wheel velocity array.
% tArray  - Time array.

idStart = find(enc.tArray <= tfl.tEncStart);
idStart = idStart(end);
last = find(tfl.tLog == 0);
last = last(1)-1;
duration = tfl.tLog(last);
idEnd = find(enc.tArray >= tfl.tEncStart+duration);
idEnd = idEnd(1);
n = idEnd-idStart;

[vlArray,vrArray,tArray] = deal(zeros(1,n));
for i = 1:n
    tArray(i) = enc.tArray(i+idStart)-enc.tArray(idStart);
    dt = enc.tArray(i+idStart)-enc.tArray(i+idStart-1);
    vlArray(i) = (enc.log(i+idStart).left-enc.log(i+idStart-1).left)/(dt*1000);
    vrArray(i) = (enc.log(i+idStart).right-enc.log(i+idStart-1).right)/(dt*1000);
end

end

