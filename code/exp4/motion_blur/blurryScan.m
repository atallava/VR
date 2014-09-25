%
load map_for_blur_test
load sim_sep6_1

% same as in data_sep25_micro_blur
pose0 = [2.3; 1.97; pi/2+pi/4];
[~,w] = robotModel.vlvr2Vw(-0.1,0.1);
ranges = zeros(1,360);

for i = 1:360
    t = (i-1)*0.2/360;
    pose = pose0;
    pose(3) = pose(3)+w*t;
    laserPose = robotModel.laser.refPoseToLaserPose(pose);
    [r,alpha] = map.getRAlpha(laserPose,robotModel.laser.maxRange,deg2rad(i-1));
    mu = rsim.pxRegBundleArray(1).regressorArray{i}.predict([r alpha]);
    sigma = rsim.pxRegBundleArray(2).regressorArray{i}.predict([r alpha]);
    pz = rsim.pxRegBundleArray(3).regressorArray{i}.predict([r alpha]);
    ranges(i) = rangeSimulator.sampleFromParamArray([mu; sigma; pz],rsim.fitClass);
end

ri = rangeImage(struct('ranges',ranges));