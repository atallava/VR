function p = myKde2(Z,Zq,bwZ)
    % Z is M x 2, data
    % Zq is Q x 2, query points for pdf
    % bwZ is bandwidth
    
    M = size(Z,1);
    Q = size(Zq,1);
    kernelParams.h = bwZ;
    K = pdist2(Z,Zq,@(x,y) kernelRBF2(x,y,kernelParams)); % K is [M,Q]
    p = sum(K,1)/M;
end