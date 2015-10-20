options.verbose = 1;
% Input module
options.inputModule.addDelay = 0;
options.inputModule.tDelay = 0.125; % in s
options.inputModule.addNoise = 0;
options.inputModule.delV = 0.0281;
options.inputModule.delW = 0.0019;

% Encoders module
options.encodersModule.addDelay = 0;
options.encodersModule.tDelay = 0.1; % in s
options.encodersModule.addNoise = 0;
options.encodersModule.delVl = 0.0138;
options.encodersModule.delVr = 0.0225;

% Laser module
options.laserModule.addParametricNoise = 0;
options.laserModule.calibLaser = 0;
% LaserClass input
laserClassInput.maxRange = 4.5; % in m
laserClassInput.rangeRes = 0.001; % in m
laserClassInput.bearings = deg2rad(0:359);
laserClassInput.nullReading = 0; 
laserClassInput.Tsensor =   [1 0 -0.1; ...
	0 1 0; ...
	0 0 1]; 
options.laserModule.laserClassInput = laserClassInput;

simOptionsName = 'C:\Users\abhijeet\Desktop\mrpl\neato_matlab\sim\mats\sim_options.mat';
save(simOptionsName,'options');