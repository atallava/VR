function components = constructComponentsFromOptions(options)
% Input module
if options.verbose; fprintf('Input Module: '); end
if options.inputModule.addDelay && options.inputModule.addNoise
	if options.verbose; fprintf('delayedNoisyInput.\n'); end
	components.inputModule = delayedNoisyInput(options.inputModule.tDelay, ...
		options.inputModule.delV,options.inputModule.delW);
elseif options.inputModule.addDelay
	if options.verbose; fprintf('delayedInput.\n'); end
	components.inputModule = delayedInput(options.inputModule.tDelay);
elseif options.inputModule.addNoise
	if options.verbose; fprintf('noisyInput.\n'); end
	components.inputModule = noisyInput(options.inputModule.delV,options.inputModule.delW);
else
	if options.verbose; fprintf('simpleInput.\n'); end
	components.inputModule = simpleInput();
end

% Encoders module
if options.verbose; fprintf('Encoders Module: '); end
if options.encodersModule.addDelay && options.encodersModule.addNoise
	if options.verbose; fprintf('delayedNoisyEncoders.\n'); end
	components.encodersModule = delayedNoisyEncoders(options.encodersModule.tDelay, ...
		options.encodersModule.delVl,options.encodersModule.delVr);
elseif options.encodersModule.addDelay
	if options.verbose; fprintf('delayedEncoders.\n'); end
	components.encodersModule = delayedEncoders(options.encodersModule.tDelay);
elseif options.encodersModule.addNoise
	if options.verbose; fprintf('noisyEncoders.\n'); end
	components.encodersModule = noisyEncoders(options.encodersModule.delVl,options.encodersModule.delVr);
else
	if options.verbose; fprintf('simpleEncoders.\n'); end
	components.encodersModule = simpleEncoders();
end

% Laser module
if options.verbose; fprintf('Laser Module: '); end
if options.laserModule.addParametricNoise
	if options.verbose; fprintf('parametricNoiseLaser.\n'); end
	components.laserModule = parametricNoiseLaser(options.laserModule.laserClassInput);
elseif options.laserModule.calibLaser
	if options.verbose; fprintf('calibratedLaser.\n'); end
	components.laserModule = calibratedLaser(options.laserModule.laserClassInput);
else
	if options.verbose; fprintf('simpleLaser.\n'); end
	components.laserModule = simpleLaser(options.laserModule.laserClassInput);
end
end