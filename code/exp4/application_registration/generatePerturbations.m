function dx = generatePerturbations(xLim,nSamples)
%GENERATEPERTURBATIONS Generate additive perturbations sampled uniformly
% from a range.
% 
% dx = GENERATEPERTURBATIONS(xLim,nSamples)
% 
% xLim    - Specify limits to sample uniformly from. Array of 
%            size dimX x 2
% nSamples - Scalar.
% 
% dx       - Array of size dimX x nSamples. To be added to a state.

dimX = size(xLim,1);
dx = zeros(dimX,nSamples);
for i = 1:dimX
    dx(i,:) = rand(1,nSamples)*(xLim(i,2)-xLim(i,1))+xLim(i,1);
end

