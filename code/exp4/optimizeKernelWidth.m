%optimize error wrt kernel window size

clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27

dpInput.poses = poses;
dpInput.rHist = rh;
dpInput.obsArray = obsArray(:,rh.pixelIds);

h0 = 0.07;
options = optimoptions('fmincon','Display','iter');
h = fmincon(@(x) errorOnKernelWidth(dpInput,x),h0,[],[],[],[],0,Inf,[],options);

