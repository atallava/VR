robotBBox.xv = robotModel.bBox(:,1); 
robotBBox.yv = robotModel.bBox(:,2);

fnameRobotBBox = '../data/robot_bbox';
save(fnameRobotBBox,'robotBBox');