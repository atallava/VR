% useful if switching from one case to another
rmpath(pwd);
rmpath([pwd '/algos_obj_wrappers']);
rmpath([pwd '/model_obj_wrappers']);
rmpath([pwd '/models']);
rmpath([pwd '/data']);

exp4Path = [exp14Path '/../exp4'];
% for algos/detection
rmpath(genpath([exp4Path '/application_detection/']))
