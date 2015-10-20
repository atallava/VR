% test bounding box placed around trajectory
pose1 = [0;0;0];
pose2 = [0.4;0.4;0];

traj = swingStraight(pose1,pose2);
turnBBox = robotModel.bBox*sqrt(2);

%%
P1.x = traj.bBox(:,1); P1.y = traj.bBox(:,2); P1.hole = ones(1,size(traj.bBox,1));
S(1).P = P1;
P2.x = turnBBox(:,1); P2.y = turnBBox(:,2); P2.hole = ones(1,size(turnBBox,1));
S(2).P = P2;
