function stat = meanOutput(algoTemplate,params,dataset)
d = length(dataset);
outputs = zeros(1,d); % who knew output was going to be a scalar?
for i = 1:d
	inputStruct.data = dataset{i};
	inputStruct.params = params;
	outputs(i) = algoTemplate(inputStruct);
end
stat = mean(outputs);
end