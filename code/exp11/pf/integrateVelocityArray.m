function poseOut = integrateVelocityArray(poseIn,VArray,wArray,dtArray)

T = length(dtArray);
poseOut = poseIn;
for i = 1:T
	w = wArray(i);
	v = VArray(i);
	dt = dtArray(i);
	poseOut(3) = poseOut(3)+w*dt; poseOut(3) = mod(poseOut(3),2*pi);
	poseOut(1) = poseOut(1)+v*cos(poseOut(3))*dt;
	poseOut(2) = poseOut(2)+v*sin(poseOut(3))*dt;
end
end