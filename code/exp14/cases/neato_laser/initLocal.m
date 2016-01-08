exp14Path = [pwd '/../..'];
addpath(pwd);
addpath([pwd '/models']);
addpath([pwd '/data']);
addpath([pwd '/algos/algo_obj_wrappers']);

exp4Path = [exp14Path '/../exp4'];
% for algos/detection
addpath(genpath([exp4Path '/application_detection/']))
