function particlesOut = resampleParticles(particlesIn,weights)

P = length(particlesIn);
particlesOut = particlesIn;
% if low variance, don't resample
ids = randsample(1:P,P,true,weights);
for i = 1:P
	particlesOut(i).pose = particlesIn(ids(i)).pose;
end
end