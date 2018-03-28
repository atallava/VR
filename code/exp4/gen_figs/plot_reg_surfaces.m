% what are shapes of the regressor surfaces?

%% load
relPathSim = '../data/sim_sep6_1';
load(relPathSim, 'rsim');

%% pick regressors
muRegBundle = rsim.pxRegBundleArray(1);
sigmaRegBundle = rsim.pxRegBundleArray(2);
pNullRegBundle = rsim.pxRegBundleArray(3);

% pick a bearing
% bearingId = randsample(360,1);
% interesting bearings are 244, 39
bearingId = 244;
fprintf('bearing id: %d\n', bearingId);
muReg = muRegBundle.regressorArray{bearingId};
sigmaReg = sigmaRegBundle.regressorArray{bearingId};
pNullReg = pNullRegBundle.regressorArray{bearingId};

%% viz mu 
% reg = muReg;
reg = sigmaReg;
% reg = pNullReg;

hfig = figure; hold on; box on;
markerSize = 400;
scatter3(reg.XTrain(:,1), reg.XTrain(:,2), reg.YTrain, ...
    'r.', 'sizeData', markerSize);

[X, Y, Z] = getSurfablePtsFromReg(reg);
surf(X, Y, Z);

xlabel('nominal range r (m)'); ylabel('incidence angle \alpha (rad)'); 

zlabel('\mu (m)');
zlabel('\sigma (m)');
% zlabel('P_{null}');

view(-30,15);

fontSize = 15;
set(gca, 'fontsize', fontSize);

