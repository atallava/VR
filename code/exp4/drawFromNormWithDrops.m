function res = drawFromNormWithDrops(paramArray)
% paramArray is 3 x number of pixels

nPix = size(paramArray,2);
res = zeros(1,nPix);
for i = 1:nPix
    if rand < paramArray(3,i)
        res(i) = 0;
    else
        res(i) = random('normal',paramArray(1,i),paramArray(2,i));
    end
end
end

