clear all; clc;
fn = [1 0];
xtrain = rand(5,1)*10;
ytrain = polyval(fn,xtrain);
reg = nonParametricRegressor(struct('XTrain',xtrain,'YTrain',ytrain,'kernelFn',@kernelBox,'kernelParams',struct('h',2)));
xtest = rand(3,1)*10;
ytest = reg.predict(xtest);

hf = figure;
axis equal;
plot(xtrain,ytrain,'b+');
hold on;
plot(xtest,ytest,'r+');
hold off;

