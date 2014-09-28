function [scanArray,tArray] = laserHist2scanArray(lzr,tfl)
%LASERHIST2SCANARRAY 
% 
% [scanArray,tArray] = LASERHIST2SCANARRAY(lzr,tfl)
% 
% lzr       - laserHistory object.
% tfl       - trajectoryFollower object.
% 
% scanArray - Cell array of scans.
% tArray    - Timestamps

idStart = find(lzr.tArray <= tfl.tEncStart);
idStart = idStart(end);
last = find(tfl.tLog == 0);
last = last(1)-1;
duration = tfl.tLog(last);
idEnd = find(lzr.tArray >= tfl.tEncStart+duration);
idEnd = idEnd(1);
n = idEnd-idStart;

tArray = zeros(1,n);
scanArray = cell(1,n);
for i = 1:n
    tArray(i) = lzr.tArray(i+idStart)-lzr.tArray(idStart);
    scanArray{i} = lzr.log(i+idStart).ranges;
end


end

