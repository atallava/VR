function objSamples = algoObjOverSamples(data,algoObj,algoParamsSamples)
%ALGOOBJOVERSAMPLES 
% 
% objSamples = ALGOOBJOVERSAMPLES(data,algoObj,algoParamsSamples)
% 
% data              - 
% algoObj           - 
% algoParamsSamples - 
% 
% objSamples        - 

debugFlag = false;

nSamples = size(algoParamsSamples,1);
objSamples = zeros(1,nSamples);

clockLocal = tic();
for i = 1:nSamples
    algoParams = algoParamsSamples(i);
    objSamples(i) = algoObj(data,algoParams);
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('calcLossAlgodev:Computation time: %.2fs.\n',tComp);
end

end