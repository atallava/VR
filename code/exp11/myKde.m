function p = myKde(Z,Zq,bwZ)
    % Z is M x 1, data
    % Zq is Q x 1, query points for pdf
    % bwZ is bandwidth
    
    if isrow(Z); Z = Z'; end
    if isrow(Zq); Zq = Zq'; end    
    
    M = size(Z,1);
    Q = size(Zq,1);
    kernelParams.h = bwZ;
    K = pdist2(Z,Zq,@(x,y) kernelRBF2(x,y,kernelParams)); % K is [M,Q]
    p = sum(K,1)/M;
end