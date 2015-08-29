% load files
% map
fNameMap = 'cluttered_box_map';
load(fNameMap);
% field pts
fName = [fNameMap '_field_pts'];
load(fName);
% ground truth
in.source = 'sim-laser-gencal';
in.tag = 'exp11-loss-field';
in.date = '150821'; 
in.index = '';
fname = buildDataFileName(in);
dataGt = load(fname);
% comparator
in.tag = 'exp11-loss-field-occmap';
in.index = '3';
fname = buildDataFileName(in);
dataOm = load(fname);
% dreg
in.tag = 'exp11-loss-field-dreg-output';
in.index = '3';
fname = buildDataFileName(in);
dataDReg = load(fname);
% train poses
in.tag = 'exp11-mapping';
in.index = '3';
fname = buildDataFileName(in);
load(fname);

%% helpers
histDistance = @histDistanceEuclidean;
nFieldPts = length(fieldPts);
xc = dataOm.xc;

%% viz ranges
close all;
% pick field point
fieldPtId = 140;
hIds = (fieldPtId-1)*sensor.nBearings+1:fieldPtId*sensor.nBearings;
pose = [fieldPts(fieldPtId).x; fieldPts(fieldPtId).y; 0];

% gt ranges
rangesGt = sampleFromHistogram(dataGt.hArray(hIds,:),xc,1);
riGt = rangeImage(struct('ranges',rangesGt,'bearings',sensor.bearings));
hfGt = riGt.plotXvsY(pose);
title('gt');
movegui(hfGt,'center');

% comparator ranges
rangesOm = sampleFromHistogram(dataOm.hArray(hIds,:),xc,1);
riOm = rangeImage(struct('ranges',rangesOm,'bearings',sensor.bearings));
hfOm = riOm.plotXvsY(pose);
title('om');
movegui(hfOm,'west');

% dReg ranges
rangesDReg = sampleFromHistogram(dataDReg.hArray(hIds,:),xc,1);
riDReg = rangeImage(struct('ranges',rangesDReg,'bearings',sensor.bearings));
hfDReg = riDReg.plotXvsY(pose);
title('dReg');
movegui(hfDReg,'east');

%% viz hist
close all;
hId = randsample(hIds,1);

% comparator
hf1 = vizHists(dataGt.hArray(hId,:),dataOm.hArray(hId,:),xc);
suptitle('om');
movegui(hf1,'west');

% dReg
hf2 = vizHists(dataGt.hArray(hId,:),dataDReg.hArray(hId,:),xc);
suptitle('dReg');
movegui(hf2,'east');

