function snippet = genCodeStructFieldsToVars(inputStruct)
%GENCODESTRUCTFIELDSTOVARS
%
% snippet = GENCODESTRUCTFIELDSTOVARS(inputStruct)
%
% inputStruct - Structure with relevant fields.
%
% snippet     - String.

    f = fields(inputStruct);
    snippet = [];
    for i = 1:length(f)
        line = [f{i} ' = ' 'inputStruct.' f{i} ';'];
        line = sprintf('%s\n',line);
        fprintf('%s',line);
        snippet = [snippet line];        
    end
end