function [vlArray,vrArray,tArray] = logsFromTrajectoryFollower(tfl)

last = find(tfl.tLog == 0);
last = last(1)-1;
vlArray = tfl.vlLog(1:last);
vrArray = tfl.vrLog(1:last);
tArray = tfl.tLog(1:last);
end