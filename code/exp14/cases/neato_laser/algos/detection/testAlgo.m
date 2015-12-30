% init
% load data
fname = 'data/data_real';
data = load(fname);

% algo params
nMin = 8;
errorThresh = 0.02;

%% test algo
vizFlag = true;
steppingFlag = 0; % use with viz when stepping through data

load('data/target_length','targetLength');
load data/target_lines_by_conf
lineCandAlgo = @(x1,x2,x3,x4) lineCand(x1,x2,x3,x4,nMin,errorThresh);

nData = length(data.X);
% getPR needs packaged scans and targetLines
scans = cell(1,nData);
targetLinesByConf = cell(1,nData);
for i = 1:nData
    targetLinesByConf{i} = data.X(i).targetLines;
    scans{i} = data.Y(i).ranges;
end

clockLocal = tic;
[nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandAlgo);
if (sum(nDetected) == 0) && (sum(nCorrect) == 0)
    p = 0;
else
    p = sum(nCorrect)/sum(nDetected);
end
r = sum(nCorrect)/sum(nTargets);
if (p == 0) && (r == 0)
    obj = 0;
else
    obj = -2*p*r/(p+r);
end

fprintf('Precision: %.2f.\n',p);
fprintf('Recall: %.2f.\n',r);
fprintf('Obj: %.2f.\n',obj);