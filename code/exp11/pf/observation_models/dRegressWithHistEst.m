function res = dRegressWithHistEst(XTrain,ZTrain,X,bwX,p)
% predict densities at some z|x
% ZTrain is a cell array of length N.
% XTrain is N x dimX
% Z is array of size R x 1
% X is array of size Q x dimX
% bwX, bwZ are respective kernel widths
% p is histogram estimate, [N,R]
% res is array of size Q x R

N = size(XTrain,1);
Q = size(X,1);

% some resizing
% if isrow(X)
%     X = X';
% end

throwCols = find(cellfun(@isempty,ZTrain));

% at some XTrain there is no data
p(:,throwCols) = [];
assert(~isempty(p),'ZTRAIN IS EMPTY.');

kernelParams.h = bwX;

% traditional: full kernels
K = pdist2(XTrain(setdiff(1:N,throwCols),:),X,@(x,y) kernelRBF2(x,y,kernelParams));
% normalize each column of K
colSum = sum(K,1);
% avoid appearance of NaNs
colSum(colSum == 0) = eps;
% K is N x Q
W = bsxfun(@rdivide,K,colSum);

res = p*W;
res = res';
end

