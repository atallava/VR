tmp = 'createTrajectorySnapshots.m generateSampleTrajectories.m generateSimScansAtSamples.m generateWaypoints.m getRegCov.m getRegFilters.m getRflStats.m mockRun.m motionCov.m runSimulatedRegFilters.m';
scriptsOld = strsplit(tmp);
nScripts = length(scriptsOld);
scriptsNew = cell(1,nScripts);

for i = 1:nScripts
    scriptOld = scriptsOld{i};
    scriptNew = camelCaseToUnderscoreCase(scriptOld);
    cmd = sprintf('mv %s %s', scriptOld, scriptNew);
    system(cmd);
    scriptsNew{i} = scriptNew;
end

