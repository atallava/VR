function risk = modelRiskObs(model,dataset,lossFn)
nElements = length(dataset);
risk = 0;
for i = 1:nElements
    X = dataset.X(i);
    Y = dataset.Y(i);
    risk = risk+lossFn(X,Y,model);
end
end