load processed_data_sep19

pixelIds = [350:360 1:10];
laser = laserClass(struct('bearings',deg2rad(pixelIds-1)));
inputStruct = struct('poses',[],'obsArray',{obsArray(:,pixelIds)},'laser',laser);
inputStruct.trainPoseIds = [];
inputStruct.testPoseIds = [];
dp = dataProcessor(inputStruct);

%% fit pdf models to training data
fprintf('Fitting pixel models...\n');
inputStruct = struct('fitClass',@normWithDrops,'data',{dp.obsArray});
pdfs = pdfBundle(inputStruct);

%%
load full_predictor_sep6_1
pxId = 360; id = find(pixelIds == pxId);
sReg = sigmaPxRegBundle.regressorArray{pxId};
pzReg = pzPxRegBundle.regressorArray{pxId};
nPoses = size(obsArray,1);
[sPred,pzPred] = deal(zeros(1,nPoses));
for i = 1:nPoses
	sPred(i) = sReg.predict([pdfs.paramArray(i,1,id) 0]);
	pzPred(i) = pzReg.predict([pdfs.paramArray(i,1,id) 0]);
end


