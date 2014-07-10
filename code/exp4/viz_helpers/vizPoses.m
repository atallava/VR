function hf = vizPoses(localizer,poses,trainPoseIds,testPoseIds)
%vizPoses visualize test and training poses on map
% localizer is an instance of lineMapLocalizer
% poses is a 3 x num poses array
% trainPoseIds, testPoseIds are rows/ columns

hf = localizer.drawLines();
figure(hf); hold on;
for i = trainPoseIds
    quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'g','LineWidth',2);
end
for i = testPoseIds
    quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'r','LineWidth',2);
end
annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'green: training poses','red: test poses'});
xlabel('x (m)');
ylabel('y (m)');
hold off;
end

