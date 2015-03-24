clearAll;
load processed_data_bsim_160215

%%
inputStruct = struct('obsArray',{obsArray(trainPoseIds,:)},'obsIds',2,'poses',poses(:,trainPoseIds),'laser',robotModel.laser);
sc = sensorCarver(inputStruct);
elements = sc.elements;

%% pick bin elements
% current object specification is transform + bounding box
Tbin2world = [1 0 .88; ...
	0 1 1.2; ...
	0 0 1];
binBox.x = 0.22+0.2;
binBox.y = 0.30+0.2; % some padding
flag = pickObjElements(elements,Tbin2world,binBox);
binElements = elements(flag);
inputStruct = struct('Tobj2world',Tbin2world,'elements',binElements,'bBox',binBox);
carvedBin = carvedObject(inputStruct);
carvedBin.interpolateElements();
inputStruct = struct('Tobj2world',eye(3),'elements',elements(~flag));
carvedRoom = carvedObject(inputStruct);

%% create test scene of room
clear e1 e2 e3
e1 = carvedRoom.elements;
T = buildT2(deg2rad(0),[1.2; 1.2]);
e2 = carvedBin.transformObject(T);

T = buildT2(deg2rad(-90),[0.85; 1.8]);
e3 = carvedBin.transformObject(T);
elements = [e1 e2 e3];

%% create simulator instance
vsim = vaneSimulator(sc.laser);
vsim.setScene(elements);

%% simulate
pose = [0.5; 1; deg2rad(10)];
ranges = vsim.simulate(pose);
ri = rangeImage(struct('ranges',ranges));
ri.plotXvsY(pose);
