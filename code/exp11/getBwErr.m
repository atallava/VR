function bwErr = getBwErr(bwXArray,bwZArray,errFn)
%GETBWERR Errors for a range of bandwidths over some holdout data. 
% 
% bwErr = GETBWERR(bwXArray,bwZArray,errFn)
% 
% bwXArray - 
% bwZArray - 
% errFn    - Handle to function.
% 
% bwErr    - Array of errors.

bwErr = zeros(1,length(bwXArray));
for i = 1:length(bwXArray)
    bwX = bwXArray(i);
    bwZ = bwZArray(i);
    bwErr(i) = errFn(bwX,bwZ);
end
end