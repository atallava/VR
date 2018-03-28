function [X,Y,Z] = getSurfablePtsFromReg(reg)
%GETSURFABLEPTSFROMREG To visualize the regression surface.
%
% [X,Y,Z] = GETSURFABLEPTSFROMREG(reg)
%
% reg - abstractRegressor-derived object. Not sure. Has to have fields
% XTrain and YTrain. XTrain must have dimension 2.
%
% X   -
% Y   -
% Z   -

x1Nodes = getNodes(reg.XTrain(:,1));
x2Nodes = getNodes(reg.XTrain(:,2));
[X,Y] = meshgrid(x1Nodes, x2Nodes);
Z = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(X,2)
        Z(i,j) = reg.predict([X(i,j) Y(i,j)]);
    end
end
end

function nodes = getNodes(vec)
minVec = min(vec);
maxVec = max(vec);
nNodes = 30;
nodes = linspace(minVec, maxVec, nNodes);
end