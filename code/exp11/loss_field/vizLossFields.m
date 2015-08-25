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

%% comparator loss field
lossMatOm = zeros(nFieldPts,sensor.nBearings);
count = 1;
for i = 1:nFieldPts
    for j = 1:sensor.nBearings
        lossMatOm(i,j) = histDistance(dataGt.hArray(count,:),dataOm.hArray(count,:));
        count = count+1;
    end
end
lossFieldOm = mean(lossMatOm,2);

%% dreg loss field
lossMatDreg = zeros(nFieldPts,sensor.nBearings);
count = 1;
dummy = zeros(1,4501);
for i = 1:nFieldPts
    for j = 1:sensor.nBearings
%         lossMatDreg(i,j) = histDistance(dataGt.hArray(count,:),dataDReg.hArray(count,:));
        lossMatDreg(i,j) = histDistance(dataGt.hArray(count,:),dummy);
        count = count+1;
    end
end
lossFieldDReg = mean(lossMatDreg,2);

%% plot
% colour limits
cmin = min([lossFieldOm; lossFieldDReg]);
cmax = max([lossFieldOm; lossFieldDReg]);

% comparator
% hf1 = map.plot();
hf1 = figure;
hold on;
scatter(poses(1,trainIds),poses(2,trainIds),100,'r','o');
scatter([fieldPts.x],[fieldPts.y],40,lossFieldOm,'filled');
colorbar;
caxis([cmin cmax]);
xlabel('x (m)'); ylabel('y (m)'); 
axis equal;
title('occupancy map loss field');

% dreg
% hf2 = map.plot();
hf2 = figure;
hold on;
scatter(poses(1,trainIds),poses(2,trainIds),100,'r','o');
scatter([fieldPts.x],[fieldPts.y],40,lossFieldDReg,'filled');
colorbar;
caxis([cmin cmax]);
xlabel('x (m)'); ylabel('y (m)');
axis equal;
title('dReg loss field');







