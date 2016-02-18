% parameters
displRange = [15; 25];
ARange = [1.5; 5];
freqMultiplierSet = 1:0.5:3;

fixedSpeed = 0.1;
fixedYawRate = 0;
resn = 0.1;

%% sine paths
nSamples = 35;

displSamples = uniformSamplesInRange(displRange,nSamples);
ASamples = uniformSamplesInRange(ARange,nSamples);
freqMultiplierSamples = randsample(freqMultiplierSet,nSamples,true);
freqSamples = 2*pi.*freqMultiplierSamples./displSamples';

for i = 1:nSamples
    pathFun = sinFnHandle(freqSamples(i),ASamples(i));
    xFine = 0:0.01:displSamples(i);
    yFine = pathFuns(xFine);
    [x,y] = pruneFinePathPts(xFine,yFine,resn);
    speed = fixedSpeed*ones(size(x));
    yawRate = fixedYawRate*ones(size(x));
    
    fname = sprintf('../data/generated_paths/sine_path_%02d.txt',i);
    savePath(x,y,speed,yawRate,fname);
end

%% square paths
nSamples = 15;

displSamples = uniformSamplesInRange(displRange,nSamples);
ASamples = uniformSamplesInRange(ARange,nSamples);
freqMultiplierSamples = randsample(freqMultiplierSet,nSamples,true);
freqSamples = 2*pi.*freqMultiplierSamples./displSamples';

fixedSpeed = 0.1;
fixedYawRate = 0;
resn = 0.1;
for i = 1:nSamples
    pathFun = squareFnHandle(freqSamples(i),ASamples(i));
    xCoarse = 0:0.01:displSamples(i);
    yCoarse = pathFun(xCoarse);
    
    % because square fn doesn't connect to x-axis
    xCoarse = [0 xCoarse displSamples(i)];
    yCoarse = [0 yCoarse 0];
    
    [xFine,yFine] = addToCoarsePathPts(xCoarse,yCoarse,resn);
    [x,y] = pruneFinePathPts(xFine,yFine,resn);
    speed = fixedSpeed*ones(size(x));
    yawRate = fixedYawRate*ones(size(x));
    
    fname = sprintf('../data/generated_paths/square_path_%02d.txt',i);
    savePath(x,y,speed,yawRate,fname);
end
