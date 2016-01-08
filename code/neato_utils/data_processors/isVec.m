function res = isVec(data)
res = false;
if isrow(data) || iscolumn(data)
   res = true;
end
end