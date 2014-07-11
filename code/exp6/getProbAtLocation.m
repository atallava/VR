function res = getProbAtLocation(pdf,x)
% x is nQueries x dimX
% right now works for dimX = 3

% TODO: Needs debugging.

nCenters = length(pdf.w);
nQueries = size(x,1);
res = zeros(nQueries,1);

dx = [1 1 1]*0.05;
boxVertices  = {[0.5 0.5 0.5], [0.5 0.5 -0.5], [-0.5 0.5 -0.5], [-0.5 0.5 0.5], [0.5 -0.5 -0.5], [0.5 -0.5 0.5], [-0.5 -0.5 0.5], [-0.5 -0.5 -0.5]};
boxSigns = [1 -1 1 -1 1 -1 1 -1];
cdfShifted = repmat({zeros(nQueries,1)},1,8);

for i = 1:nCenters
    try
        mvncdf([0 0 0],pdf.Mu(:,i)',pdf.Cov{i});
    catch
        continue
    end
    for j = 1:length(boxVertices)
        shiftedX = bsxfun(@plus,x,boxVertices{j}.*dx);
        cdfShifted{j} = cdfShifted{j}+pdf.w(i)*mvncdf(shiftedX,pdf.Mu(:,i)',pdf.Cov{i});
    end
end

for i = 1:8
   res = res+boxSigns(i)*cdfShifted{i};
end

end

