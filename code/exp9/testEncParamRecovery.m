% check if known parameters can be recovered
vl = dataEncVel(1).vlArray;
vr = dataEncVel(1).vrArray;
t = dataEncVel(1).tArray;

vl1 = vl.*(1+params(1));
vr1 = vr.*(1+params(2));
[V1,w1] = robotModel.vlvr2Vw(vl,vr);
[~,p1] = integrateVelocities(dataEncVel(1).startPose,V1,w1,t);

ptrue = [0.0138 0.0225];
% ptrue = [0 0];
vl2 = vl.*(1+ptrue(1));
vr2 = vr.*(1+ptrue(2));
[V2,w2] = robotModel.vlvr2Vw(vl,vr);
[~,p2] = integrateVelocities(dataEncVel(1).startPose,V2,w2,t);

p0 = poseHistory{1};

%%
figure; hold on; axis equal;
plot(p0(1,:),p0(2,:),'b');
plot(p1(1,:),p1(2,:),'r');
plot(p2(1,:),p2(2,:),'g');