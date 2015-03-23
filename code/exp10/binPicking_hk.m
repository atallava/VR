clearAll;
load processed_data_hk_160315
load nsh_4227_corner_plank_map

%%
inputStruct = struct('obsArray',{obsArray(trainPoseIds,:)},'obsIds',2,'poses',poses(:,trainPoseIds),'laser',hkLaser);
sc = sensorCarver(inputStruct);
elements = sc.elements;

%% pick bin elements
% current object specification is transform + bounding box
Tbin2world = [1 0 1.1; ...
	0 1 1.45; ...
	0 0 1];
binBox.x = 0.20+0.2;
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
%%
T = buildT2(deg2rad(0),[0.7; 1.65]);
e2 = carvedBin.transformObject(T);

T = buildT2(deg2rad(-90),[1.2; 0.88]);
e3 = carvedBin.transformObject(T);
%%
elements = [e1 e2 e3];

%% create simulator instance
vsim = vaneSimulator(sc.laser);
vsim.setScene(elements);

%% simulate
pose = poses(:,17);
ranges = vsim.simulate(pose);
%%
ri = rangeImage(struct('ranges',ranges,'bearings',hkLaser.bearings));
ri.plotXvsY(pose);

%%
Tbin2world = [1 0 1.1; ...
	0 1 1.45; ...
	0 0 1];
binBox.x = 0.20+0.2;
binBox.y = 0.30+0.2; % some padding
binElements = {};

for i = [3 4 8 10]
    inputStruct = struct('obsArray',{obsArray(i,:)},'obsIds',1:10,'poses',poses(:,i),'laser',hkLaser);
    sc = sensorCarver(inputStruct);
    elements = sc.elements;
    
    flag = pickObjElements(elements,Tbin2world,binBox);
    binElements{end+1} = elements(flag);
end
 


