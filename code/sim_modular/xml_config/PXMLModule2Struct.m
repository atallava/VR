function moduleStruct = PXMLModule2Struct(pxmlModule)
% pxmlModule comes out of parseXML
% moduleStruct is a direct struct with name-value pairs

moduleAttr = pxmlModule.Attributes;
attrNames = {moduleAttr.Name};
for j = 1:length(moduleAttr)
	val = str2num(moduleAttr(j).Value);
	% Values have to be either numbers or strings
	if isempty(val)
		val = moduleAttr(j).Value;
	end
	moduleStruct.(attrNames{j}) = val;
end

end

