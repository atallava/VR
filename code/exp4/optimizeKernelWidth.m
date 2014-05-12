%optimize error wrt kernel window size
warning('off')
clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27

dpInput.poses = poses;
dpInput.rHist = rh;
dpInput.obsArray = obsArray(:,rh.pixelIds);

h0 = 0.07; lambda0 = 0.1;
options = optimoptions('fmincon','Display','iter');
%params = fmincon(@(x) errorOnKernelWidth(dpInput,x(1),x(2)),[h0;lambda0],[],[],[],[],[0; 0],[Inf; Inf],[],options);
params = fmincon(@(x) errorOnKernelWidth(dpInput,x,lambda0),h0,[],[],[],[],0,Inf,[],options);
