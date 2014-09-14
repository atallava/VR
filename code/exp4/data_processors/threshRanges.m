function threshRanges(lzr)
%THRESHRANGES Set ranges < 6cm and > 5.5m to 0.
% 
% THRESHRANGES(lzr)
% 
% lzr - laserHistory object.

minThresh = 0.06;
maxThresh = 5.5;
for i = 1:length(lzr.log)
    lzr.log(i).ranges(lzr.log(i).ranges < minThresh) = 0;
    lzr.log(i).ranges(lzr.log(i).ranges > maxThresh) = 0;
end

end

