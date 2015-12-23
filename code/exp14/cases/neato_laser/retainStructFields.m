function outStruct = retainStructFields(inputStruct,retainFields)
    %RETAINSTRUCTFIELDS Retain specified fields from a struct (array).
    %
    % outStruct = RETAINSTRUCTFIELDS(inputStruct,retainFields)
    %
    % inputStruct  - Struct (array).
    % retainFields - String or cell.
    %
    % outStruct    - Struct (array).
    
    inputStructFields = fieldnames(inputStruct);
    flag = ismember(inputStructFields,retainFields);
    throwFields = inputStructFields(~flag);
    outStruct = rmfield(inputStruct,throwFields);
end