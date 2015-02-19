function meanWithSampleSize(ivl)
%MEANWITHSAMPLESIZE Plot mean with error bars with increasing sample size.
% 
% MEANWITHSAMPLESIZE(ivl)
% 
% ivl - Array of intervals.

n = length(ivl);
numVec = linspace(1,n,10);

for i = 1:length(numVec)
	mu(i) = mean(ivl(1:numVec(i)));
	s(i) = std(ivl(1:numVec(i)));
end
errorbar(numVec,mu,2*s);

end

