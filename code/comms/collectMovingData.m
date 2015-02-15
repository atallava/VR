%% log while executing some trajectory
% assumes rob, rstate exist in workspace

load('motion_vars')
start = [0;0;0];
goal = [2,1.75,pi/3];
csp = tp.planPath(start,goal);

count = 1;
done = false;
clear encHistArray lzrHistArray
while ~done
	fprintf('Run %d\n',count);
	rstate.reset(start);
	tfl.resetTrajectory(csp);
	enc = encHistory(rob);
	lzr = laserHistory(rob);
	tfl.execute(rob,rstate);
	pause(0.5);
	enc.stopListening();
	encHistArray(count) = enc;
	lzr.stopListening();
	lzrHistArray(count) = lzr;
	count = count+1;
	done = input('Done? 0/1: ');
end
