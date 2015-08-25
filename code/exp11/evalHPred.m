function [meanErr,err] = evalHPred(hArray,hPredArray,histDistance)
    %EVALHPRED
    %
    % [meanErr,err] = EVALHPRED(hArray,hPredArray,histDistance)
    %
    % hArray       - [Q,R] gt histograms.
    % hPredArray   - [Q,R] predicted histograms.
    % histDistance - Function handle.
    %
    % meanErr      - Scalar.
    % err          - Size [1,Q].

   Q = size(hArray,1);
   err = zeros(1,Q);
   for i = 1:Q
       err(i) = histDistance(hArray(i,:),hPredArray(i,:));
   end
   meanErr = mean(err);
end