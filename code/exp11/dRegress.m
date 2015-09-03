function [res,p] = dRegress(XTrain,ZTrain,Z,X,bwX,bwZ)
% predict densities at some z|x
% ZTrain is a cell array of length N.
% XTrain is N x dimX
% Z is array of size R x 1
% X is array of size Q x dimX
% bwX, bwZ are respective kernel widths
% res is array of size Q x R

N = size(XTrain,1);
R = length(Z);
Q = size(X,1);

% some resizing
if isrow(Z)
    Z = Z';
end
if isrow(X)
    X = X';
end

p = zeros(R,N);
throwCols = find(cellfun(@isempty,ZTrain));

% histogram density estimate 
p = ranges2Histogram(ZTrain,Z)'; % [N,R]

% kernel density estimate
% for i = 1:N
%     % density estimates at Z|XTrain(i)
%     if isempty(ZTrain{i})
%         continue;
%     else
%         p(:,i) = ksdensity(ZTrain{i},Z,'bandwidth',bwZ);
%     end
% end

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

% alt: retain top neighbours and loop through queries
% XTrain = XTrain(setdiff(1:N,throwCols),:);
% frac = 1;
% nNbrs = round(frac*size(XTrain,1));
% [nearestIds,kernelValues] = knnsearch(XTrain,X,'K',nNbrs,'Distance', ...
%     @(x,y) kernelRBF2(x,y,kernelParams)); % both are [Q,nNbrs]
% W = zeros(Q,N); % this will finally multiply with p
% % get ids of W to fill based on nearestIds
% offset = [0:(Q-1)]'*Q;
% W_ids = bsxfun(@plus,nearestIds,offset);
% W_ids = W_ids(:);
% % normalize kernelValues
% colSum = sum(kernelValues,2);
% % avoid nasty nans
% colSum(colSum == 0) = eps; 
% kernelValues = bsxfun(@rdivide,kernelValues,colSum);
% kernelValues = kernelValues(:);
% W(W_ids) = kernelValues;
% W = W';

res = p*W;
res = res';
end

