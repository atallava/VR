function [res,p] = dRegressSmoothing(XTrain,ZTrain,Z,X,bwX,bwZ)
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
if iscolumn(X)
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

kernelParams.h = bwX;

% retain top neighbours and loop through queries
XTrain = XTrain(setdiff(1:N,throwCols),:);
frac = 0.2;
nNbrs = round(frac*size(XTrain,1));
res = zeros(Q,R);

K = pdist2(XTrain,X,@(x,y) kernelRBF2(x,y,kernelParams)); % [N,Q]
[sortedK,sortedIds] = sort(K,1,'descend');
kernelValues = sortedK(1:nNbrs,:); % [nNbrs,Q]
sortedIds = sortedIds(1:nNbrs,:);
for i = 1:Q
    if sum(kernelValues(:,i)) == 0
        continue;
    end
    XTrain_i = XTrain(sortedIds(:,i),:); % [nNbrs,dimX]
    XTrain_i = [XTrain_i ones(nNbrs,1)]; % add bias
    YTrain_i = p(:,sortedIds(:,i))'; % [nNbrs,R];
    W_i = kernelValues(:,i)/sum(kernelValues(:,i));
    W_i = diag(W_i);
    linearFit_i = (XTrain_i'*W_i*XTrain_i)\(XTrain_i'*W_i*YTrain_i); % [dimX,R]
    X_i = [X(i,:) 1]; % [1,dimX]
    pred = X_i*linearFit_i; % [1,R]
    pred(pred < 0) = 0; % hack
    res(i,:) = pred;
end

% [nearestIds,kernelValues] = knnsearch(XTrain,X,'K',nNbrs,'Distance', ...
%     @(x,y) kernelRBF2(x,y,kernelParams)); % both are [Q,nNbrs]
% % step through queries
% for i = 1:Q
%     if sum(kernelValues(i,:)) == 0
%         continue;
%     end
%     XTrain_i = XTrain(nearestIds(i,:),:); % [nNbrs,dimX]
%     XTrain_i = [XTrain_i ones(nNbrs,1)]; % add bias
%     YTrain_i = p(:,nearestIds(i,:))'; % [nNbrs,R];
%     W_i = kernelValues(i,:)/sum(kernelValues(i,:));
%     W_i = diag(W_i);
%     linearFit_i = (XTrain_i'*W_i*XTrain_i)\(XTrain_i'*W_i*YTrain_i); % [dimX,R]
%     X_i = [X(i,:) 1]; % [1,dimX]
%     res(i,:) = X_i*linearFit_i; % [1,R]
% end
end

