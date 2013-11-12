function viewBoxes(ranges,j)
%view box around interest region for ranges at a bunch of orientations
%j indicates the set of measurements
%better way to pass around parameters
load('processed_data1','box','theta','angles','dpose');
id1 = 0:50:400; id1(1) = 1; id2 = 10;
int_box = getBox(box{j},dpose);

for i = 1:length(id1)    
    th = deg2rad(theta(j)*(id1(i)-1));
    coords = [squeeze(ranges(id1(i),id2,:)).*cos(angles') squeeze(ranges(id1(i),id2,:)).*sin(angles')];
    coords = coords';
    R = getRotMat(th);
    %rotate range data
    coords = R*coords;
    hf = figure;
    %plot range data
    scatter(coords(1,:),coords(2,:));
    hold on;
    box_pts = [int_box; int_box(1,:)]; %just to draw a closed int_boxangle
    %draw interest box
    plot(box_pts(:,1),box_pts(:,2),'r');
    axis equal;
    title(gca,sprintf('%d',id1(i)));
    waitforbuttonpress;
    close(gcf);
end
end