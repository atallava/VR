function res = sampleNormWithDrops(paramArray)
%SAMPLENORMWITHDROPS Function version of normWithDrops.sample
% 
% res = SAMPLENORMWITHDROPS(paramArray)
% 
% paramArray - Array of length 3.
% 
% res        - One sample.

mu = paramArray(1); sigma = paramArray(2);
pZero = paramArray(3);

if rand < pZero
	res = 0;
else
	if isnan(sigma)
		res = mu;
	elseif isnan(mu)
		res = 0;
	else
		res = normrnd(mu,sigma);
	end
end
end