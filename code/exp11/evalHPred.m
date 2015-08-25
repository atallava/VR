function [meanErr,err] = evalHPred(hArray,hPredArray,histDistance)
    % evaluate predicted histogram array
    
   Q = size(hArray,1);
   err = zeros(1,Q);
   for i = 1:Q
       err(i) = histDistance(hArray(i,:),hPredArray(i,:));
   end
   meanErr = mean(err);
end