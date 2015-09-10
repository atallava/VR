function particlesOut = motionUpdate(particlesIn,VArray,wArray,dtArray,etaV,etaW)

if iscolumn(VArray)
	VArray = VArray';
end
if iscolumn(wArray)
	wArray = wArray';
end

P = length(particlesIn);
T = length(dtArray);

particlesOut = struct('pose',{});

sigmaV = sign(VArray)*etaV.*abs(VArray); % [1,T]
sigmaW = sign(wArray)*etaW.*abs(wArray); % [1,T]
% noisy linear velocities
VNoisy = rand(P,T);
VNoisy = bsxfun(@times,VNoisy,sigmaV.^2);
VNoisy = bsxfun(@plus,VNoisy,VArray);
% noisy angular velocities
wNoisy = rand(P,T);
wNoisy = bsxfun(@times,wNoisy,sigmaW.^2);
wNoisy = bsxfun(@plus,wNoisy,wArray);

for i = 1:P
	particlesOut(i).pose = integrateVelocityArray(particlesIn(i).pose,VNoisy(i,:),...
		wNoisy(i,:),dtArray);
end
end