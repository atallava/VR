inputStruct.pre = '../gt_factory/data/';
inputStruct.source = 'gt';
inputStruct.tag = 'traj';
inputStruct.date = '150804';
inputStruct.index = '5';

fname = buildDataFileName(inputStruct);
load(fname);

map = [];
duration = max([tPose(end),tInputV(end),tEnc(end),tLzr(end)]);