% check if known parameters can be recovered
vl = dataCommVel(1).vlArray;
vr = dataCommVel(1).vrArray;
t = dataCommVel(1).tArray;

[V1,w1] = robotModel.vlvr2Vw(vl,vr);
V1 = V1.*(1+params(1));
w1 = w1+params(2)*ones(size(w1));
[~,p1] = integrateVelocities(dataCommVel(1).startPose,V1,w1,t);

ptrue = [0.00153 0.0248];
[V2,w2] = robotModel.vlvr2Vw(vl,vr);
V2 = V2.*(1+ptrue(1));
w2 = w2+ptrue(2)*ones(size(w1));
[~,p2] = integrateVelocities(dataCommVel(1).startPose,V2,w2,t);

p0 = poseHistory{1};

%%
figure; hold on; axis equal;
plot(p0(1,:),p0(2,:),'b');
plot(p1(1,:),p1(2,:),'r');
plot(p2(1,:),p2(2,:),'g');