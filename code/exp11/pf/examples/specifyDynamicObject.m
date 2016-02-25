dynamicXLen = 0.2;
dynamicYLen = 0.05;
dynamicBBox.xv = [-1 1 1 -1 -1]*dynamicXLen*0.5;
dynamicBBox.yv = [-1 -1 1 1 -1]*dynamicYLen*0.5;

%% save
fnameDynObj = '../data/dynamic_object';
save(fnameDynObj,'dynamicBBox');