%% visualize how good/bad odometry is
load raw_poses
load raw_ranges

bearings = deg2rad(-130:0.25:129.75);
figure; hold on;
for i = 1:size(raw_poses,2)
   rr = squeeze(raw_ranges(i,10,:));
   ri = rangeImage(struct('ranges',rr,'bearings',bearings)); ri.cleanup(0.01,5);
   ptsLocal = [ri.xArray; ri.yArray; ones(1,length(ri.xArray))];
   poseObj = pose2D(raw_poses(:,i));
   ptsWorld = poseObj.T*ptsLocal;
   color = rand(1,3); color = color/sum(color);
   plot(ptsWorld(1,:),ptsWorld(2,:),'+','color',color);
   k = waitforbuttonpress;
end
