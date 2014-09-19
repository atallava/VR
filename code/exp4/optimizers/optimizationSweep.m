% Sweep across parameters and regressors for optimal parameters
clearAll
load optimization_sweep_data_1
inputStruct.regClass = @pixelRegressorBundle; 

%% Mu
fprintf('Optimizing for Mu...\n');
inputStruct.regClassInput = muPxRegBundle.inputStruct;
resMu = fn2(inputStruct);
fprintf('Computation took %.2fs.\n',resMu.np.duration+resMu.lwl.duration);

%% S
fprintf('Optimizing for S...\n');
inputStruct.regClassInput = sigmaPxRegBundle.inputStruct;
resS = fn2(inputStruct);

%% Pz
fprintf('Optimizing for pZ...\n');
inputStruct.regClassInput = pzPxRegBundle.inputStruct;
resPz = fn2(inputStruct);

%% Save to file
save('optimization_sweep_results_3.mat','resMu','resS','resPz');





