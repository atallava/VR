% specify environment
fNameMap = 'cluttered_box_map';
load(fNameMap);
fNameSupport = [fNameMap '_support'];
load(fNameSupport);
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%%
fieldPts = struct('x','y');
xMax = max(support.xv);
xMin = min(support.xv);
yMax = max(support.yv);
yMin = min(support.yv);
scale = 0.3; % adapt to map size
xGrid = xMin:scale:xMax;
yGrid = yMin:scale:yMax;

count = 1;
for i = 1:length(xGrid)
    for j = 1:length(yGrid)
        x = xGrid(i); y = yGrid(j); 
        pose = [x; y; 0];
        tBBox = transformPolygon(pose,bBox);
        if isValidPose(map,support,tBBox)
            fieldPts(count).x = x;
            fieldPts(count).y = y;
            count = count+1;
        end
    end
end
   
%%
fNameFieldPts = ['../data/' fNameMap '_field_pts'];
save(fNameFieldPts,'scale','fieldPts');

