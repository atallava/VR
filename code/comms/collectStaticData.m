% assumes rob exists
% log enc with laser on/off
numRuns = 15;
runDuration = 10;

for i = 1:numRuns
	enc = encHistory(rob);
	t1 = tic();
	while toc(t1) < runDuration
		pause(0.01);
	end
	enc.stopListening();
	encHistArray(i) = enc;
end

%% log laser
% laser has to be on
numRuns = 15;
runDuration = 10;

for i = 1:numRuns
	lzr = laserHistory(rob);
	t1 = tic();
	while toc(t1) < runDuration
		pause(0.01);
	end
	lzr.stopListening();
	lzrHistArray(i) = lzr;
end




