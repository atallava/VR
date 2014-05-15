function nllArray = getDataNLL(data,params,fitClass)
%get nll of data wrt parameters
% data is a num poses x num pixels cell array
% params is num poses x num params x num pixels
% fitClass is a function handle 

whos
nPoses = size(data,1);
nPixels = size(data,2);
nllArray = zeros(nPoses,nPixels);

for i = 1:nPoses
   for j = 1:nPixels
       tempObj = fitClass(squeeze(params(i,:,j)),1);
       nllArray(i,j) = tempObj.negLogLike(data{i,j});
   end
end
end

