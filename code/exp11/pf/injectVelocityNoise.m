function [VNoisy,wNoisy] = injectVelocityNoise(VArray,wArray,etaV,etaW)

if iscolumn(VArray)
	VArray = VArray';
end
if iscolumn(wArray)
	wArray = wArray';
end

T = length(VArray);
sigmaV = sign(VArray)*etaV.*abs(VArray); % [1,T]
sigmaW = sign(wArray)*etaW.*abs(wArray); % [1,T]

VNoisy = VArray+rand(1,T).*sigmaV.^2;
wNoisy = wArray+rand(1,T).*sigmaW.^2;
wNoisy = mod(wNoisy,2*pi);
end