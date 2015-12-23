function res = kernelRBF2(x1,x2,kernelParams)
%KERNELRBF2
%
% res = KERNELRBF2(x1,x2,kernelParams)
% 
% x1           - 1 x dimX.
% x2           - n x dimX.
% kernelParams - struct with fields ('h'), bandwidth. Default = 1.0 if
%                passed empty struct.
% 
% res          - [n,1] kernel values.

dimX = length(x1);
n = size(x2,1);

% h is bandwidth
if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 1.0;
end

switch numel(h)
    case 1
        % single bandwidth
        H = h^2*eye(dimX);
    case dimX
        % diagonal elements
        H = diag(h.^2);
    case dimX^2
        % full matrix
        H = h;
    otherwise
        error('INVALID BANDWIDTH INPUT');
end

if iscolumn(x1)
    x1 = x1';
end

d = bsxfun(@minus,x2,x1); % [n,d]

v1 = H\d'; % [d,n]
temp = d.*v1'; % [n,d]
temp = sum(temp,2); % [n,1]

% temp = zeros(1,n);
% for i = 1:n
%     vec = d(i,:);
%     temp(i) = vec*(H\vec');
% end

temp = exp(-0.5*temp);
normalizer = ((2*pi)^(dimX/2))*det(sqrt(H));
res = temp/normalizer;

if isrow(res)
    res = res';
end
end

