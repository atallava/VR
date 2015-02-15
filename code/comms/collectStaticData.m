% assumes rob exists in workspace
% log enc with laser on/off
numRuns = 15;
runDuration = 10;

clear encHistArray;
fprintf('Static robot encoders comm log.\n');
for i = 1:numRuns
	fprintf('Run %d\n',i);
	enc = encHistory(rob);
	t1 = tic();
	while toc(t1) < runDuration
		pause(0.01);
	end
	enc.stopListening();
	encHistArray(i) = enc;
end
fprintf('Finished.\n');

%% log laser
% laser has to be on
numRuns = 15;
runDuration = 10;

clear lzrHistArray;
fprintf('Static robot laser comm log.\n');
for i = 1:numRuns
	fprintf('Run %d\n',i);
	lzr = laserHistory(rob);
	t1 = tic();
	while toc(t1) < runDuration
		pause(0.01);
	end
	lzr.stopListening();
	lzrHistArray(i) = lzr;
end
fprintf('Finished.\n');




