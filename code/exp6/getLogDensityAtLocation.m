function res = getLogDensityAtLocation(pdf,x)
% x is nQueries x dimX

minValue = -1e6;
nCenters = length(pdf.w);
nQueries = size(x,1);
res = zeros(nQueries,1);

for i = 1:nCenters
    try
        res = res+pdf.w(i)*mvnpdf(x,pdf.Mu(:,i)',pdf.Cov{i});
    catch
        continue
    end
end
res = log(res);
res(res < minValue) = minValue;
end
