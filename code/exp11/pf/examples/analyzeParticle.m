% specify particle id
B = length(obsModelStruct.ranges);
id = 1;

%% extract particle information
particlePose = obsModelStruct.poses(:,id);
fprintf('Particle pose: \n');
disp(particlePose');
xc = obsModelStruct.sensor.readingsSet();
hParticle = obsModelStruct.h((id-1)*B+1:id*B,:);

% observed ranges
rangesObserved = obsModelStruct.ranges;
bearingsObserved = obsModelStruct.bearings;
fprintf('Observed ranges: \n');
disp(rangesObserved);
ri1 = rangeImage(struct('ranges',rangesObserved,'bearings',obsModelStruct.bearings));
hfig1 = ri1.plotXvsY(particlePose);
set(hfig1,'position',[100,617,361,277]);
WinOnTop(hfig1,true);

% nominal ranges
rangesNominalParticle = obsModelStruct.rangesNominal((id-1)*B+1:id*B);
fprintf('Nominal ranges: \n');
disp(rangesNominalParticle');
ri2 = rangeImage(struct('ranges',rangesNominalParticle,'bearings',obsModelStruct.bearings));
hfig2 = ri2.plotXvsY(particlePose);
set(hfig2,'position',[100,198,361,277]);
WinOnTop(hfig2,true);

%% save
% fnameDemo = '../data/demo_npreg_3';
fnameDemo = '../data/demo_thrun_3';
save(fnameDemo,...
    'map','dynamicMap',...
    'pose','rangesObserved','bearingsObserved',...
    'particlePose','rangesNominalParticle',...
    'hParticle','xc');