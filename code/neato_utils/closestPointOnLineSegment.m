function [rad2 , po] = closestPointOnLineSegment(pi,p1,p2)
%CLOSESTPOINTONLINESEGMENT 
% Find points on a line segment closest to given
% points and and return the square distance.
% 
% [rad2 , po] = CLOSESTPOINTONLINESEGMENT(pi,p1,p2)
% 
% pi    - Array of points of size 2 x n.
% p1    - Column of size 2, endpoint of segment.
% p2    - Column of size 2, endpoint of segment.
% 
% rad2  - Squared distance to closest point on segment.
% po    - Closest point on segment.

% dx13 = pi(1,:) - p1(1);
% dy13 = pi(2,:) - p1(2);
% dx12 = p2(1) - p1(1);
% dy12 = p2(2) - p1(2);
% dx23 = pi(1,:) - p2(1);
% dy23 = pi(2,:) - p2(2);
% v1 = [dx13 ; dy13];
% v2 = [dx12 ; dy12];
% v3 = [dx23 ; dy23];

v1 = bsxfun(@minus,pi,p1);
v2 = p2-p1;
v3 = bsxfun(@minus,pi,p2);

v1dotv2 = bsxfun(@times,v1,v2);
v1dotv2 = sum(v1dotv2,1);
v2dotv2 = sum(v2.*v2);
v3dotv2 = bsxfun(@times,v3,v2);
v3dotv2 = sum(v3dotv2,1);

nPoints = size(pi,2);
rad2 = zeros(1,nPoints);
po = zeros(2,nPoints);

% Closest is on segment
flag1 = v1dotv2 > 0.0 & v3dotv2 < 0.0;
if any(flag1)
    scale = v1dotv2/v2dotv2;
    temp = bsxfun(@plus,v2*scale,[p1(1) ; p1(2)]);
    po(:,flag1) = temp(:,flag1);
    dx = pi(1,flag1)-po(1,flag1);
    dy = pi(2,flag1)-po(2,flag1);
    rad2(flag1) = dx.*dx+dy.*dy;
end

% Closest is first endpoint
flag2 = v1dotv2 <= 0.0;
if any(flag2)
    %temp = repmat([p1(1); p1(2)],1,sum(flag2));
    temp = bsxfun(@times,ones(2,sum(flag2)),[p1(1); p1(2)]);
    po(:,flag2) = temp;
%     dx = pi(1,flag2)-po(1,flag2);
%     dy = pi(2,flag2)-po(2,flag2);
%     rad2(flag2) = dx.*dx+dy.*dy;
    rad2(flag2) = inf;
end
% Closest is second endpoint
flag3 = ones(size(1,nPoints)) & ~flag1 & ~flag2;
if any(flag3)
    %temp = repmat([p2(1) ; p2(2)],1,sum(flag3));
    temp = bsxfun(@times,ones(2,sum(flag3)),[p2(1); p2(2)]);
    po(:,flag3) = temp;
%     dx = pi(1,flag3)-po(1,flag3);
%     dy = pi(2,flag3)-po(2,flag3);
%     rad2(flag3) = dx.*dx+dy.*dy;
    rad2(flag3) = inf;
end
end