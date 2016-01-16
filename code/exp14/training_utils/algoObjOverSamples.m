function objSamples = algoObjOverSamples(dataset,algoObj,algoParamsSamples)
%ALGOOBJOVERSAMPLES 
% 
% objSamples = ALGOOBJOVERSAMPLES(data,algoObj,algoParamsSamples)
% 
% data              - 
% algoObj           - 
% algoParamsSamples - 
% 
% objSamples        - 

debugFlag = true;

nSamples = length(algoParamsSamples);
objSamples = zeros(1,nSamples);

clockLocal = tic();
for i = 1:nSamples
    algoParams = algoParamsSamples(i);
    objSamples(i) = algoObj(dataset,algoParams);
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('algoObjOverSamples:Computation time: %.2fs.\n',tComp);
end

end