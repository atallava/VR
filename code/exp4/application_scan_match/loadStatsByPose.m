function res = loadStatsByPose(choice,algo)
%LOADSTATSBYPOSE Helper function that returns data of choice.
% 
% res = LOADSTATSBYPOSE(choice)
% 
% choice - Integer, 1-5.
% algo   - String of algorithm name. If omitted, results from own-developed code is% loaded.
% res    - struct with field 'statsByPose'.

str = choiceString(choice);
if strcmp(algo,'lab8')
  fname = sprintf('%s_stats',str);
else
  fname = sprintf('%s_stats_%s',str,algo);
end

res = load(fname);

end

