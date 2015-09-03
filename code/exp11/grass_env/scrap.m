th = deg2rad(0:359);

%%
ranges = rob.laser.data.ranges;
ri = rangeImage(struct('ranges',ranges));
ri.plotXvsY();

%%
nObs = 500;
rangeArray = zeros(nObs,360);
for i = 1:nObs
	rangeArray(i,:) = rob.laser.data.ranges;
	pause(0.3);
end
fprintf('done.\n');

%%
laser = laserClass(struct());
nHCenters = round(laser.maxRange/laser.rangeRes)+1; % number of histogram centers
xc = linspace(0,laser.maxRange,nHCenters); % histogram centers

%%
ids = [0:50 310:360];
id = randsample(ids,1);
data = rangeArray(:,id);
h = hist(data,xc);
h = h/sum(h);
figure; 
hf = bar(xc,h); movegui(hf,'west');
xlabel('bins'); ylabel('count');
title(sprintf('id: %d',id));

%% 
fname = 'observations_dynamic';
save(fname,'rangeArray','laser','ids');