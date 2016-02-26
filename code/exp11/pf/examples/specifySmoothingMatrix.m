% for the spiky histograms that come from npreg
% this will be very hardcoded

% bins in histogram
H = 4501;

% weights segment
segmentLength = 401;
w = getWeightsSegment(segmentLength);

smoothingMatrix = zeros(H);

% looping over number of segments
% which is bad but not horrendous
oneSidedSegmentLength = floor(segmentLength-1)/2;
for i = 1:segmentLength
    shift = -oneSidedSegmentLength+(i-1);
    rowSubs = 1:H;
    colSubs = [1:H]+shift;
    % prevent underflow 
    if shift < 0
        colSubs = max(colSubs,1);
    elseif shift > 0
        colSubs = min(colSubs,H);
    end
    ids = sub2ind([H,H],rowSubs,colSubs);
    smoothingMatrix(ids) = smoothingMatrix(ids)+w(i);
end

%% save
fnameSmoothingMatrix = '../data/hist_smoothing_matrix_401';
save(fnameSmoothingMatrix,'smoothingMatrix','segmentLength')
