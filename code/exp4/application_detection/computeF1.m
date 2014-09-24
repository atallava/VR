function f1 = computeF1(data)
%COMPUTEF1 
% 
% f1 = COMPUTEF1(data)
% 
% data - Struct with fields ('p','r'). Precision and recall.
% 
% f1   - F1 score, scalar.

f1 = 2*data.p*data.r/(data.p+data.r);
end