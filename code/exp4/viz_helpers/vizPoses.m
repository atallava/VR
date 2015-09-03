function hf = vizPoses(map,poses,varargin)
%VIZPOSES Visualize test and training poses on map.
% 
% hf = VIZPOSES(map,poses,trainPoseIds,testPoseIds)
% 
% map          - lineMap object.
% poses        - 2 x nPoses array.
% trainPoseIds - 1d Array.
% testPoseIds  - 1d Array.
%
% hf           - Figure handle.

hf = map.plot();
figure(hf); hold on;

if nargin == 2
    for i = 1:size(poses,2);
        quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'g','LineWidth',2);
    end
elseif nargin == 4
    trainPoseIds = varargin{1};
    testPoseIds = varargin{2};
    for i = trainPoseIds
        quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'g','LineWidth',2);
    end
    for i = testPoseIds
        quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'r','LineWidth',2);
    end
    annotation('textbox',[.6,0.8,.1,.1], ...
        'String', {'green: training poses','red: test poses'});
else
    error('Incorrect number of inputs.');
end
xlabel('x (m)');
ylabel('y (m)');
hold off;
end
