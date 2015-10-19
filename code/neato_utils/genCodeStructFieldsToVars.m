function snippet = genCodeStructFieldsToVars(inputStruct)
    f = fields(inputStruct);
    snippet = [];
    for i = 1:length(f)
        line = [f{i} ' = ' 'inputStruct.' f{i} ';'];
        line = sprintf('%s\n',line);
        fprintf('%s',line);
        snippet = [snippet line];        
    end
end