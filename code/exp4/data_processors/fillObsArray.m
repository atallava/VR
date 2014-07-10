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
nPix = length(laserHist.rangeArray{end});
obsArray = cell(nPoses,nPix);
for i = 1:nPoses
    ids = laserHist.tArray >= t_range_collection(i).start & laserHist.tArray <= t_range_collection(i).end;
    temp = laserHist.rangeArray(ids);
    temp = cell2mat(temp');
    for j = 1:nPix
        obsArray{i,j} = temp(:,j);
    end    
end
end

