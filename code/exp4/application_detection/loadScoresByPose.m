function res = loadScoresByPose(choice)
%LOADSCORESBYPOSE Helper function that returns data of choice.
% 
% res = LOADSCORESBYPOSE(choice)
% 
% choice - Integer, 1-5.
% 
% res    - struct with field 'scoresByPose'.

str = choiceString(choice);
fname = sprintf('%s_scores',str);
res = load(fname);

end