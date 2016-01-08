function risk = modelObjObs(dataset,model,modelParams,lossFn)
model.pZero = modelParams.pZero;
model.alpha = modelParams.alpha;
model.beta = modelParams.beta;
risk = modelRiskObs(model,dataset,lossFn);
end