function samples = sampleFromHistogram2(h,xc1,xc2,n)
%SAMPLEFROMHISTOGRAM2 2D version of sampleFromHistogram
% 
% samples = SAMPLEFROMHISTOGRAM2(h,xc,n)
% 
% h       - [R,R] array. 
% xc1      - [R,1] array. dim 1 centers
% xc2      - [R,1] array. dim 2 centers.
% n       - Number of samples. Defaults to 1.
% 
% samples - n x 2 samples.


if nargin < 4
    n = 1;
end

% nH = size(h,1);
% if size(xc,1) < nH
%     xc = repmat(xc,nH,1);
% end

samples = zeros(n,2);
cdf1 = cumsum(sum(h,2));

for i = 1:n
	z1 = rand();
	id1 = sum(cdf1 <= z1)+1;
	samples(i,1) = xc1(id1);
	
	vec = h(id1,:)/sum(h(id1,:)); 
	cdf2 = cumsum(vec);
	z2 = rand();
	id2 = sum(cdf2 <= z2)+1;
	samples(i,2) = xc2(id2);
end
end