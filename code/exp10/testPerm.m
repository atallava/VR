% synthetic generate points
clearAll
mu1 = [1 0]; sigma1 = eye(2)*0.5^2;
mu2 = [5 0]; sigma2 = eye(2)*0.25^2;

pts1 = mvnrnd(mu1,sigma1,10);
pts2 = mvnrnd(mu2,sigma2,5);

pts = [pts1; pts2];
pts = sortrows(pts,1);
pts = pts';

%% 
scRep = sensorCentricRep('a');
scRep.rayStart = zeros(size(pts));
scRep.rayEnd = pts;
ptsNorm = sqrt(sum(pts.^2,1));
scRep.rayDirn = bsxfun(@rdivide,pts,ptsNorm);
scRep.nRays = size(pts,2);
scRep.gridCarving = gridCarver(scRep.rayEnd);
scRep.gridCarving.plotElements();
xl = xlim; yl = ylim;

scRep.calcPermeabilities();

%%
scRep.laser = laserClass(struct('bearings',deg2rad(-40:40)));
vsim = vaneSimulator(scRep);

%%
ranges = vsim.simulate([-0.5 0 0]);
simPts = bsxfun(@times,[cos(scRep.laser.bearings); sin(scRep.laser.bearings)],ranges);
figure;
plot(simPts(1,:),simPts(2,:),'b.'); axis equal;
xlim(xl); ylim(yl);


