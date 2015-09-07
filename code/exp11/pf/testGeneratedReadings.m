% test whether generated readings make sense
load('pf_readings');

%%
% integrate velocities without noise
poses = [];
poses(:,1) = poseHistory(:,1);
for i = 1:length(readings)
    if strcmp(readings(i).type,'observation')
        continue;
    end
    data = readings(i).data;
    poses(:,end+1) = integrateVelocityArray(poses(:,end),data.VArray,data.wArray,data.dtArray);
end

%%
% noisy vs clean path
hf = figure;
plot(poseHistory(1,:),poseHistory(2,:),'r.');
hold on;
plot(traj.poseArray(1,:),traj.poseArray(2,:),'b.');
axis equal;

%% step through ranges
nObs = round(0.5*(length(readings)+1));
ids = 1:10:nObs;

for i = ids
    data = readings(2*(i-1)+1).data;
    ri = rangeImage(struct('ranges',data.ranges));
    pose = poseHistory(:,i);
    hf = ri.plotXvsY(pose);
    waitforbuttonpress;
    close(hf);
end
