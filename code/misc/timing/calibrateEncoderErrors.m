load calibration_encoder_errors_data
rstate = robState([],'manual',poseStart);

skip = 1:10;
err = zeros(size(skip));
deltaT = zeros(size(skip));
for i = 1:length(skip)
    rstate.reset(poseStart);
    numSteps = length(1:skip(i):length(encArray));
    deltaT(i) = tArray(1+skip(i))-tArray(1);
    for j = 1:skip(i):length(encArray)
        rstate.setEncoders(encArray(j),tArray(j));
    end
    err(i) = poseDiffNormError(poseEnd,rstate.pose)/numSteps;
end