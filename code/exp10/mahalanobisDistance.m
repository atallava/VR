function d = mahalanobisDistance(x,mu,S)
%MAHALANOBISDISTANCE 
% 
% d = MAHALANOBISDISTANCE(x,mu,S)
% 
% x  - Query. Column vector.
% mu - Gaussian mean. Column vector.
% S  - Gaussian covariance.
% 
% d  - Distance.

d = (x-mu)'/S*(x-mu);
end
