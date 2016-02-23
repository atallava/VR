function particlesOut = motionUpdate(particlesIn,VArray,wArray,dtArray,etaV,etaW)
%MOTIONUPDATE 
% 
% particlesOut = MOTIONUPDATE(particlesIn,VArray,wArray,dtArray,etaV,etaW)
% 
% particlesIn  - Struct array with fields ('pose').
% VArray       - Vector.
% wArray       - Vector.
% dtArray      - Vector.
% etaV         - Scalar, V variance multiplier.
% etaW         - Scalar, W variance multiplier.
% 
% particlesOut - Struct array with fields ('pose').

VArray = flipVecToRow(VArray);
wArray = flipVecToRow(wArray);

P = length(particlesIn);
T = length(dtArray);

particlesOut = struct('pose',{});

sigmaV = sign(VArray)*etaV.*abs(VArray); % [1,T]
sigmaW = sign(wArray)*etaW.*abs(wArray); % [1,T]
% noisy linear velocities
VNoise = rand(P,T);
VNoise = bsxfun(@times,VNoise,sigmaV);
VNoisy = bsxfun(@plus,VNoise,VArray);
% noisy angular velocities
wNoise = rand(P,T);
wNoise = bsxfun(@times,wNoise,sigmaW);
wNoisy = bsxfun(@plus,wNoise,wArray);

for i = 1:P
	particlesOut(i).pose = integrateVelocityArray(particlesIn(i).pose,VNoisy(i,:),...
		wNoisy(i,:),dtArray);
end
end