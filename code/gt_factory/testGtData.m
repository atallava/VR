% check if ground truth data makes sense
inputStruct.pre = 'data/';
inputStruct.source = 'gt';
inputStruct.tag = 'traj';
inputStruct.date = '150804';
inputStruct.index = '5';

fname = buildDataFileName(inputStruct);
load(fname);

%% viz gt poses
plot(poseLog(1,:),poseLog(2,:),'.');
axis equal
hold on
quiver(pose0(1),pose0(2),0.4*cos(pose0(3)),0.4*sin(pose0(3)),'k','LineWidth',2); hold off;

%% times should be reasonable
fprintf('Start times:\n');
fprintf('tPose(1): %.3f\n',tPose(1));
fprintf('tInputV(1): %.3f\n',tInputV(1));
fprintf('tEnc(1): %.3f\n',tEnc(1));
fprintf('tLzr(1): %.3f\n',tLzr(1));
fprintf('\n');

fprintf('Durations:\n');
fprintf('tPose: %.3f\n',tPose(end)-tPose(1));
fprintf('tInputV: %.3f\n',tInputV(end)-tInputV(1));
fprintf('tEnc: %.3f\n',tEnc(end)-tEnc(1));
fprintf('tLzr: %.3f\n',tLzr(end)-tLzr(1));
fprintf('\n');

fprintf('First period:\n');
fprintf('tPose: %.3f\n',tPose(2)-tPose(1));
fprintf('tInputV: %.3f\n',tInputV(2)-tInputV(1));
fprintf('tEnc: %.3f\n',tEnc(2)-tEnc(1));
fprintf('tLzr: %.3f\n',tLzr(2)-tLzr(1));
fprintf('\n');

fprintf('Mean period:\n');
fprintf('tPose: %.3f\n',mean(tPose(2:end)-tPose(1:end-1)));
fprintf('tInputV: %.3f\n',mean(tInputV(2:end)-tInputV(1:end-1)));
fprintf('tEnc: %.3f\n',mean(tEnc(2:end)-tEnc(1:end-1)));
fprintf('tLzr: %.3f\n',mean(tLzr(2:end)-tLzr(1:end-1)));
fprintf('\n');

