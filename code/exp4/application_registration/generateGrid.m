function x = generateGrid(xLim,samplesByDim)
%GENERATEGRID 
% 
% x = GENERATEGRID(xLim,samplesByDim)
% 
% xLim         - Limits to sample from. Array of size dimX x 2.
% samplesByDim - Number of samples in each dimension. Array of length dimX.
% 
% x            - Array of size dimX x prod(samplesByDim)

dimX = size(xLim,1);
nX = prod(samplesByDim);
x = zeros(dimX,nX);

for i = dimX:-1:1
    vec = linspace(xLim(i,1),xLim(i,2),samplesByDim(i));
    mask = zeros(dimX,nX);
    if i == dimX
        x1 = 1;
    else
        x1 = prod(samplesByDim(i+1:dimX));
        mask(i+1:dimX,1:x1) = 1;
    end
    mask = logical(mask);
    shiftedMask = mask;
    flag = zeros(1,nX); flag(1:x1) = 1;
    shiftedFlag = logical(flag);
    for j = 1:length(vec)
        x(i,shiftedFlag) = vec(j);
        x(shiftedMask) = x(mask);
        shiftedFlag = circshift(shiftedFlag,[0 x1]);
        shiftedMask = circshift(shiftedMask,[0,x1]);
    end
end
end

