function addToLogs(fname,resXX,resXR)
%ADDTOLOGS Helper function.
% 
% ADDTOLOGS(fname,resXX,resXR)
% 
% fname - Filename, string.
% resXX - Result of simulator on simulator.
% resXR - Result of simulator on real data.

load(fname);
perf{end+1} = resXX;
perfReal{end+1} = resXR;
save(fname,'perfSim','perfReal');
end