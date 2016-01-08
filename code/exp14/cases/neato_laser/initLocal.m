exp14Path = [pwd '/../..'];
addpath(pwd);
addpath([pwd '/models']);
addpath([pwd '/data']);

exp4Path = [exp14Path '/../exp4'];
% for algos/detection
addpath(genpath([exp4Path '/application_detection/']))
