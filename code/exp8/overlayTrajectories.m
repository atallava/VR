function hf = overlayTrajectories(rflArray,mfl,map)
%OVERLAYTRAJECTORIES 
% 
% hf = OVERLAYTRAJECTORIES(rflArray,mfl,map)
% 
% rflArray - registrationFilter array.
% mfl      - motionFilter object. Nominal trajectory is here.
% map      - lineMap object.n
% 
% hf       - Figure handle.

hf = map.plot();
hold on;
plot(mfl.poseArray(1,:),mfl.poseArray(2,:),'r--');

for i = 1:length(rflArray)
    plot(rflArray(i).poseArray(1,:),rflArray(i).poseArray(2,:),'g--');
end
hold off;
xlabel('x (m'); ylabel('y (m)');

end

