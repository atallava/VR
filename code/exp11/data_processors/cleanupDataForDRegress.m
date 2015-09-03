function [X,Z,varargout] = cleanupDataForDRegress(X,Z,varargin)
%CLEANUPDATAFORDREGRESS Throw away corrupted data.
% 
% [X,Z] = CLEANUPDATAFORDREGRESS(X,Z)
% [X,Z,pIds] = CLEANUPDATAFORDREGRESS(X,Z,pIds)
% [X,Z,pIds,...] = CLEANUPDATAFORDREGRESS(X,Z,pIds,...)
% 
% X         - States. N x dimX array.
% Z         - Observations. Length N cell array.
% pIds      - Mapping from bearing to robot pose. Length N array.
% 
% X         - Cleaned X.
% Z         - Cleaned Z.
% pIds      - Cleaned pIds.


assert(nargout == nargin, 'NARGIN MUST BE EQUAL TO NARGOUT');

throwIds = [];
for i = 1:length(Z)
    z = Z{i};
    % filter 1: throw away zeroes. if too few readings remain, discard
    % observation
    oldNumZ = length(z);
    z(z == 0) = [];
    Z{i} = z;
    if length(z) < 0.7*oldNumZ
        throwIds = [throwIds i];
    end
    % filter 2: throw away any nan features
    if any(isnan(X(i,:)))
        throwIds = [throwIds i];
    end
end
X(throwIds,:) = [];
Z(throwIds) = [];

if nargin > 2
    varargout = cell(1,nargin-2);
    for i = 1:(nargin-2);
        tmp = varargin{i};
        tmp(throwIds,:) = [];
        varargout{i} = tmp;
    end
end
end