function res = fevalUnpack(fn,varargin)
% hack to simulate feval with variable number of inputs
% fn is a function handle

n = length(varargin);
res = [];

switch n
    case 1
        res = feval(fn,varargin{1});
    case 2
        res = feval(fn,varargin{1},varargin{2});
    case 3
        res = feval(fn,varargin{1},varargin{2},varargin{3});
    otherwise
        fprintf('can only handle 3 inputs\n');
end

end

