function res = dRegress2(XTrain,ZTrain,Z,X,bwX,bwZ)
% z is 2 dimensional!
% predict densities at some z|x
% ZTrain is a cell array of length N.
% XTrain is N x dimX
% Z is array of size R x 2
% X is array of size 1 x dimX
% bwX, bwZ are respective kernel widths
% res is array of size Q x R

N = size(XTrain,1);
R = length(Z);
Q = size(X,1);

% some resizing
if isrow(Z)
    Z = Z';
end
if iscolumn(X)
    X = X';
end

% 2d kde params
% circular bandwidth
gkdeParams.h = [bwZ bwZ];
nICenters1 = sqrt(size(Z,2));
% back to reshaping for gkde...
gkdeParams.x = reshape(Z(1,:),[nICenters1,nICenters1]);
gkdeParams.y = reshape(Z(2,:),[nICenters1,nICenters1]);

% R is the total bins in a 2d histogram
p = zeros(R,N);
throwCols = [];
for i = 1:N
    % density estimates at Z|XTrain(i)
	% this throwCol logic is ok?
    if isempty(ZTrain{i})
        throwCols = [throwCols i];
    else
        res = gkde2(ZTrain{i},gkdeParams);
		p(:,i) = res.pdf(:);
    end
end
% at some XTrain there is no data
p(:,throwCols) = [];
assert(~isempty(p),'ZTRAIN IS EMPTY.');

kernelParams.h = bwX;
K = pdist2(XTrain(setdiff(1:N,throwCols),:),X,@(x,y) kernelRBF2(x,y,kernelParams));
% normalize each column of K
colSum = sum(K,1);
% avoid appearance of NaNs
colSum(colSum == 0) = eps;
% K is N x Q
K = bsxfun(@rdivide,K,colSum);

res = p*K;
res = res';
end

