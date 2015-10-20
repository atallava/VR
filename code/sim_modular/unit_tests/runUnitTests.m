% specify sim
neatoSimClass = @neato3;

%% specify tests
unitTestNames = { ...
	'straightLine', ...
	'sPath', ...
	};

%% run tests
for i = 1:length(unitTestNames)
	fnName = [unitTestNames{i} 'UnitTest'];
	fnHandle = str2func(fnName);
	fnHandle(neatoSimClass);
end