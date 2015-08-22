% input
in.pre = '../data';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-mapping';
in.date = '150821'; 
in.index = '3';
fname = buildDataFileName(in);
load(fname);

%% sometimes sim produces nan readings
for i = 1:size(obsArray,1)
    for j = 1:size(obsArray,2)
        vec = obsArray{i,j};
        vec(isnan(vec)) = 0;
        obsArray{i,j} = vec;
    end
end

%% save
save(fname,'obsArray','-append');