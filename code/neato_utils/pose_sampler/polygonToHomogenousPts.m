function pts = polygonToHomogenousPts(polygon)
% polygon is struct with fields ('xv','yv')
% pts is [3,N]

N = length(polygon.xv);
pts = ones(3,N);
pts(1,:) = polygon.xv;
pts(2,:) = polygon.yv;
end

