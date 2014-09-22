% Sweep across parameters and regressors for optimal parameters
clearAll
load optimization_sweep_data
inputStruct.regClass = @pixelRegressorBundle; 

%% Mu
fprintf('Optimizing for Mu...\n');
inputStruct.regClassInput = muPxRegBundle.inputStruct;
inputStruct.regClassInput.kernelFn = @kernelRBF;
resMu = fn2(inputStruct);
fprintf('Computation took %.2fs.\n',resMu.np.duration+resMu.lwl.duration);

%% S
fprintf('Optimizing for S...\n');
inputStruct.regClassInput = sigmaPxRegBundle.inputStruct;
inputStruct.regClassInput.kernelFn = @kernelRBF;
resS = fn2(inputStruct);

%% Pz
fprintf('Optimizing for pZ...\n');
inputStruct.regClassInput = pzPxRegBundle.inputStruct;
inputStruct.regClassInput.kernelFn = @kernelRBF;
resPz = fn2(inputStruct);

%% Save to file
save('optimization_sweep_results_6.mat','resMu','resS','resPz');





