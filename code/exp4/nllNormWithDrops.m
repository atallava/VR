function res = nllNormWithDrops(params,data)
% negative log likelihood of data wrt to fitNormal parameters
% params: [mu, sigma, pZero]

vec1 = pdf('normal',data,params(1),params(2))*(1-params(3));
vec2 = (data == 0)*params(3);
res = -log(sum(vec1+vec2));        

end

