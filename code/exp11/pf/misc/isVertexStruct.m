function res = isVertexStruct(var)
    %ISVERTEXSTRUCT Check if variable is vertex struct. A vertex struct has
    % fields ('xv','yv'). Both fields are numeric vectors of the same size.
    %
    % res = ISVERTEXSTRUCT(var)
    %
    % var - Variable.
    %
    % res - Logical.

    res = true;
    if ~isfield(var,'xv')
        res = false;
        return;
    end
    if ~isfield(var,'yv')
        res = false;
        return;
    end
    if ~(isnumeric(var.xv))
        res = false;
        return;
    end
    if ~(isnumeric(var.yv))
        res = false;
        return;
    end
    if length(var.xv) ~= length(var.yv)
        res = false;
        return;
    end
end