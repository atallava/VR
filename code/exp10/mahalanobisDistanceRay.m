function [d,tMin] = mahalanobisDistanceRay(p0,r,mu,S)
%MAHALANOBISDISTANCERAY 
% 
% d = MAHALANOBISDISTANCERAY(p0,r,mu,S)
% 
% p0 - Origin of ray. 
% r  - Direction of ray.
% mu - Gaussian mean.
% S  - Gaussian covariance.
% 
% d  - Distance

r = r/norm(r);
tMin = (r'/S)*(mu-p0);
tMin = tMin/(r'/S*r);
p = p0+tMin*r;
d = mahalanobisDistance(p,mu,S);
end