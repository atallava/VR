% visualize distribution of points in r-alpha space
clc;

id = 6;
hf = figure; 
axis equal; hold on;
plot(rAlphaTrain(:,1,id),0.1*rAlphaTrain(:,2,id),'go');
plot(rAlphaTest(:,1,id),0.1*rAlphaTest(:,2,id),'ro');
xlabel('range (m)');
ylabel('0.1*angle of incidence (rad)');
title(sprintf('pixel %d',pixelIds(id)));
legend('training data','test data');

% plot some influence region around the training points
rad = 0.03;
for i = 1:length(trainPoseIds)
    rCirc = rAlphaTrain(i,1,id)+rad*cos(deg2rad(0:359));
    alphaCirc = 0.1*rAlphaTrain(i,2,id)+rad*sin(deg2rad(0:359));
    plot(rCirc,alphaCirc,'b:','LineWidth',2);
end
