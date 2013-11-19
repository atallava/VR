function  hf = plotMapFromRange(pose,ranges)
%poses is Nx3, ranges is Nxnum_returns
num_returns = size(ranges,2);
ndata = size(ranges,1);
angles = 0:1:(num_returns-1); angles = deg2rad(angles*(360/num_returns));
angles = repmat(angles,ndata,1)+repmat(pose(:,3),1,num_returns);
rx = ranges.*cos(angles);
ry = ranges.*sin(angles);
rx = rx + repmat(pose(:,1),1,num_returns); ry = ry + repmat(pose(:,2),1,num_returns);
rx = reshape(rx,1,numel(rx));
ry = reshape(ry,1,numel(ry));
hf = figure;
scatter(rx,ry,5,'b');
end

