function lines = getRawLines(rangeImage_obj,target_length)
% scan all points for line candidates

lines = {};
for i = 1:rangeImage_obj.npix
    [error,th,num,left,right] = findLineCandidate(rangeImage_obj,i,target_length,0);
    if num == 1
        continue;
    end
    lines{end+1} = [error,th,num,i,left,right];
end
end
