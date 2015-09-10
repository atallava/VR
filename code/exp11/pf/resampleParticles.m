function particlesOut = resampleParticles(particlesIn,weights)

P = length(particlesIn);
particlesOut = particlesIn;
% if low variance, don't resample
ids = randsample(1:P,P,true,weights);
particlesOut = particlesIn(ids);
end