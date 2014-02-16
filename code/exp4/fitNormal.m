function params = fitNormal(data)
% same work as fitNWithDrops, but a function
% params: [mu;sigma;pZero]
if nargin == 0
    % if empty call, return the length of params
    params = 3;
    return;
end

nData = length(data);
zeroIds = find(data == 0);
pZero = length(zeroIds)/nData;
if pZero == 1
    params = [NaN NaN 1];
    return;
else 
    data(zeroIds) = [];
    if length(data) == 1
        % only a single data point available
        % set this to the mean
        mu = data(1);
        sigma = 0;
        params = [mu sigma pZero];
        return;
    end
    try
        mle_params = mle(data,'distribution','normal');
    catch
        warning('BAD DATA');
    end
    params = [mle_params pZero];
end
end

