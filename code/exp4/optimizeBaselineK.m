%optimize error wrt baseline sigma predictor

clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27

skip = 1;
pixelIds = 1:skip:360; bearings = deg2rad(pixelIds-1);
dpInput.poses = poses;
dpInput.obsArray = obsArray(:,pixelIds);
laser = laserClass(struct('bearings',bearings));
dpInput.laser = laser;

K0 = 1e-3;
options = optimoptions('fmincon','Display','iter');
K = fmincon(@(x) errorOnBaselineSigma(dpInput,x),K0,[],[],[],[],0,Inf,[],options);
