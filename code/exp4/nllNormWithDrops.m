function res = nllNormWithDrops(params,data)
% negative log likelihood of data wrt to fitNormal parameters
% params: [mu, sigma, pZero]

vec1 = pdf('normal',data,params(2),params(3))*(1-params(1));
vec2 = (data == 0)*params(1);
res = -log(sum(vec1+vec2));        

end

