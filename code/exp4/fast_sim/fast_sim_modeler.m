clearAll;
load full_predictor_sep6_2

%% null readings
% mean of observed for each pixel
y = pzPxRegBundle.YTrain;
y = squeeze(y);
pz = mean(y,1);

%% mean fits
% use only nominal range
rAlpha = muPxRegBundle.inputPoseTransf.transform(dp.XTrain);
r = squeeze(rAlpha(:,1,:));
alpha = squeeze(rAlpha(:,2,:));
mus = squeeze(muPxRegBundle.YTrain);
mufit = cell(1,360);
ndata = zeros(1,360);
for i = 1:360
	y = mus(:,i);
	x = r(:,i);
	ids = setdiff(1:length(y),find(isnan(y))); 
	mufit{i} = polyfit(x(ids),y(ids),1);
	ndata(i) = length(ids);
end

%% sigma fits
% sigma \neq 0
% cutoff ranges at some threshold
sigmas = squeeze(sigmaPxRegBundle.YTrain);
sigmafit = cell(1,360);
ndata = zeros(1,360);
for i = 1:360
	y = sigmas(:,i);
	x = r(:,i);
	ids = setdiff(1:length(y),find(isnan(y)));
	sigmafit{i} = polyfit(x(ids),y(ids),2);
	ndata(i) = length(ids);
end

% treat the data-starved
flag = ndata < 0.3*max(ndata);
for i = find(flag)
	sigmafit{i} = sigmafit{1};
end

%% predict
rAlphaTest = muPxRegBundle.inputPoseTransf.transform(dp.XTest);
rTest = squeeze(rAlphaTest(:,1,:));
alphaTest = squeeze(rAlphaTest(:,2,:));
musTest = squeeze(testPdfs.paramArray(:,1,:));
sigmasTest = squeeze(testPdfs.paramArray(:,2,:));
pzTest = squeeze(testPdfs.paramArray(:,3,:));

% mus
musPred = zeros(size(musTest));
nTest = size(pzTest,1);
for i = 1:nTest
	for j = 1:360
		musPred(i,j) = polyval(mufit{j},rTest(i,j));
	end
end

% sigmas
sigmasPred = zeros(size(sigmasTest));
nTest = size(pzTest,1);
for i = 1:nTest
	for j = 1:360
		sigmasPred(i,j) = polyval(sigmafit{j},rTest(i,j));
	end
end

%% calculate error

pzErr = abs(pzTest-repmat(pz,nTest,1));
pzErr = mean(pzErr(:));

musErr = abs(musTest-musPred);
musErr(isnan(musErr)) = [];
musErr = mean(musErr(:));

sigmasErr = abs(sigmasTest-sigmasPred);
sigmasErr(isnan(sigmasErr)) = [];
sigmasErr = mean(sigmasErr(:));

%%
load nsh3_corridor
lsim = laserSimulator(mufit,sigmafit,pz,deg2rad(0:359));
lsim.setMap(map);
rsim.setMap(map);

%%
pose = [0; 1.5; deg2rad(40)];
ranges1 = rsim.simulate(pose);
ranges2 = lsim.simulate(pose);
ri1 = rangeImage(struct('ranges',ranges1));
ri2 = rangeImage(struct('ranges',ranges2));
ri1.plotXvsY(pose); title('rsim');
ri2.plotXvsY(pose); title('lsim');

