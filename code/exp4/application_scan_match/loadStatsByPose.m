function res = loadStatsByPose(choice)
%LOADSTATSBYPOSE Helper function that returns data of choice.
% 
% res = LOADSTATSBYPOSE(choice)
% 
% choice - Integer, 1-5.
% 
% res    - struct with field 'statsByPose'.

switch choice
    case 1
        res = load('real_stats');
    case 2
        res = load('baseline_stats');
    case 3
        res = load('sim_stats');
    case 4
        res = load('sim_pooled_stats');
    case 5
        res = load('sim_local_match_stats');
    otherwise
        error('CHOICE NOT IN AVAILABLE.');
end

end

