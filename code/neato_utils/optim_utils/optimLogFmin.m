function stop = optimLogFmin(x,optimValues,state,logFilename)
    %OPTIMLOG To be used as an argument for OutputFcn with optimizers.
    %
    % stop = OPTIMLOG(x,optimValues,state,logFilename)
    %
    % x           -
    % optimValues -
    % state       -
    % logFilename - String
    %
    % stop        -
    
    stop = false;
    posn = strfind(logFilename,'.txt');
    if isempty(posn)
        logFilename = [logFilename '.txt'];
    end
    if strcmp(state,'init')
        fid = fopen(logFilename,'w');
    else
        fid = fopen(logFilename,'at');
    end
    line = sprintf('fval: %.5f\n',optimValues.fval);
    fprintf(fid,line);
    line = sprintf('x: %s\n\n',mat2str(x,5));
    fprintf(fid,line);
end