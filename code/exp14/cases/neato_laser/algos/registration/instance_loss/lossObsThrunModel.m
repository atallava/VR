function loss = lossObsThrunModel(X,Y,model)
probArray = model.probArrayAtState(X);
loss = model.negLogLike(probArray,Y.ranges);
end