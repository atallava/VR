clear all; close all; clc;
fn = [1 0 0];
xtrain = rand(10,1)*10;
xtrain = sort(xtrain);
ytrain = polyval(fn,xtrain);
input = struct('XTrain',xtrain,'YTrain',ytrain,'kernelFn',@kernelBox,'kernelParams',struct('h',1.1));
reg = nonParametricRegressor(input);
xtest = rand(10,1)*10;
xtest = sort(xtest);
ytest = reg.predict(xtest);

hf = figure;
axis equal;
plot(xtrain,ytrain,'b+');
hold on;
plot(xtest,ytest,'r+');
hold off;

