function components = simRobotComponentsConstructor(fname)
configStruct = parseXML(fname);
names = {configStruct.Name};
for i = 1:length(names)
	if isequal(names{i},'configuration')
		configStruct = configStruct(i);
		break;
	end
end

% Extract children
children = configStruct.Children;
names = {children.Name};

% Assemble components
for i = 1:length(names)
	if isequal(names{i},'input_module')
		% Input module.
		moduleStruct = PXMLModule2Struct(children(i));
		if moduleStruct.add_delays
			components.inputModule = delayedInput(moduleStruct.t_delay);
		else
			components.inputModule = mostRecentInput();
		end
	end
end

% Assemble simRobot
end

