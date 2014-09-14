load doorframe

ldfrot = lineObject();
R = [0 1; -1 0];
ldfrot.lines = (R*ldf.lines')';

% left wall
lv =  [0 324.5; ...
	35.5 0; ...
	0 63.5; ...
	100.5 0; ...
	239.5 0; ...
	100.5 0; ...
	263 0; ...
	100.5 0; ...
	280.5 0; ...
	100.5 0; ...
	0 -149.5; ...
	0 -100.5; ...
	0 -150];
isdoorl = zeros(1,size(lv,1));
isdoorl([4 6 8 10]) = 1;
isdoorrot = zeros(1,size(lv,1));
isdoorrot(12) = 1;
	
o = [-287.5 -199]; % calculated from global origin
lwall = lineObject();
lwall.lines = o;
for i = 1:size(lv,1)
	if isdoorl(i)
		pts = bsxfun(@plus,ldf.lines,o);
		lwall.lines = [lwall.lines; pts];
	elseif isdoorrot(i)
		pts = bsxfun(@plus,ldfrot.lines,o);
		lwall.lines = [lwall.lines; pts];
	end
	o = o+lv(i,:);
	if ~isdoorl(i)
		lwall.lines = [lwall.lines; o];
	end
end

lwall.lines = lwall.lines*0.01;

%% right wall

% right doorframe
rdf = lineObject();
rdf.lines = ldf.lines();
rdf.lines(:,2) = -rdf.lines(:,2);

rv = [0 406.5; ...
	21.5 0; ...
	100.5 0; ...
	454.5 0; ...
	100.5 0; ...
	24 0; ...
	0 -210];
isdoorr = zeros(1,size(rv,1));
isdoorr([3 5]) = 1;

o = [0 -406.5]; % calculated from global origin
rwall = lineObject();
rwall.lines = o;
for i = 1:size(rv,1)
	if isdoorr(i)
		pts = bsxfun(@plus,rdf.lines,o);
		rwall.lines = [rwall.lines; pts];
	end
	o = o+rv(i,:);
	if ~isdoorr(i)
		rwall.lines = [rwall.lines; o];
	end
end

rwall.lines = rwall.lines*0.01;