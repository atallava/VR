exp14Path = [pwd '/../../'];
addpath([pwd '/algos_obj_wrappers']);
addpath([pwd '/models']);
addpath([pwd '/data']);

exp4Path = [exp14Path '/../exp4'];
% for laser model
addpath([exp4Path '/kernels']);
% for algos/detection
addpath(genpath([exp4Path '/application_detection/']))