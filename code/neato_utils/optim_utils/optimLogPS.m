function [stop,options,optchanged] = optimLogPS(optimvalues,options,flag,logFilename)
    %OPTIMLOG To be used as an argument for OutputFcn with patternsearch.
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
    optchanged = false;
    posn = strfind(logFilename,'.txt');
    if isempty(posn)
        logFilename = [logFilename '.txt'];
    end
    if strcmp(flag,'init')
        fid = fopen(logFilename,'w');
    else
        fid = fopen(logFilename,'at');
    end
    line = sprintf('fval: %.5f\n',optimvalues.fval);
    fprintf(fid,line);
    line = sprintf('x: %s\n\n',mat2str(optimvalues.x,5));
    fprintf(fid,line);
end