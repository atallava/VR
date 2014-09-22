function threshRanges(lzr)
%THRESHRANGES Set ranges < 6cm and > 5.5m to 0. Also throw this funny
% 0.08 reading which I cannot explain.
% 
% THRESHRANGES(lzr)
% 
% lzr - laserHistory object.

load bizarreReading;
minThresh = 0.06;
maxThresh = 5.5;
for i = 1:length(lzr.log)
    lzr.log(i).ranges(lzr.log(i).ranges < minThresh) = 0;
    lzr.log(i).ranges(lzr.log(i).ranges > maxThresh) = 0;
    lzr.log(i).ranges(lzr.log(i).ranges == bizarreReading) = 0;
end

end

