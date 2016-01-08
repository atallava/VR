function loss = lossObsThrunModel(X,Y,model)
    %LOSSOBSTHRUNMODEL
    %
    % loss = LOSSOBSTHRUNMODEL(X,Y,model)
    %
    % X     -
    % Y     -
    % model -
    %
    % loss  -
        
    probArray = model.probArrayAtState(X);
    loss = model.negLogLike(probArray,Y.ranges);
    if isnan(loss)
        error('lossObsThrunModel:invalidOutput','loss is nan.');
    end
    if isinf(loss)
         error('lossObsThrunModel:invalidOutput','loss is inf.');
    end
end