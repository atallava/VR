function obsArray = fillObsArray(laserHist,t_range_collection)
%FILLOBSARRAY 
% 
% obsArray = FILLOBSARRAY(laserHist,t_range_collection)
% 
% laserHist          - laserHistory object.
% t_range_collection - struct array with fields ('start','end'), denotes
%                      periods (in laser's clock) when range data was collected
% 
% obsArray           - nPoses x nPix cell array

nPoses = length(t_range_collection);
nPix = length(laserHist.log(1).ranges);
obsArray = cell(nPoses,nPix);
for i = 1:nPoses
    ids = laserHist.tArray >= t_range_collection(i).start & laserHist.tArray <= t_range_collection(i).end;
    temp = cat(1,laserHist.log(ids).ranges);
    for j = 1:nPix
        obsArray{i,j} = temp(:,j);
    end    
end
end

