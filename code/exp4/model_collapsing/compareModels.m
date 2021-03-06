function res = compareModels(model1,model2,x1,y1,x2,y2)
%COMPAREMODELS Compare two models (hypotheses).
% 
% res = COMPAREMODELS(model1,model2,x1,y1,x2,y2)
% 
% model1 - abstractRegressor-derived object.
% model2 - abstractRegressor-derived object.
% x1     - Test input for model1, nTest x dimX.
% y1     - Test output for model1, nTest x dimY.
% x2     - Test input for model2, nTest x dimX.
% y2     - Test output for model2, nTest x dimY.
% 
% res    - 1 if model1 wins, -1 if model2 wins, 0 if no conclusion, 2 if
%          draw

% how much lower error than other model is needed
M  = 1e-2; 

e11 = modelErrorOnData(model1,x1,y1);
e12 = modelErrorOnData(model1,x2,y2);
e22 = modelErrorOnData(model2,x2,y2);
e21 = modelErrorOnData(model2,x1,y1);

if e11 < e21-M && e12 < e22-M
    res = 1;
elseif e22 < e12-M && e21 < e11-M
    res = -1;
elseif abs(e11-e21) < M && abs(e22-e12) < M
    res = 2;
else
    res = 0;
end

end

function err = modelErrorOnData(model,x,y)
% Find model error on some data. Throw out nans and outliers.

M = 1e-2;
largeCost = M*nParams; % ensure that will not be accepted as a match
yThreshold = 0.1; 
badY = abs(y-x) > yThreshold; % outliers
yPred = model.predict(x);
err = abs(y-yPred);
err(badY) = [];
err(isnan(err)) = []; % throw nans
err = mean(err);
end