function getTheta(ranges)

id1 = 1; id2 = 10;
load('raw_data.mat','angles');
figure;
scatter(squeeze(ranges(id1,id2,:)).*cos(angles'),squeeze(ranges(id1,id2,:)).*sin(angles'))
axis equal
title(gca,sprintf('id1:%d,id2:%d',id1,id2));

id1 = 180; id2 = 20;
figure;
scatter(squeeze(ranges(id1,id2,:)).*cos(angles'),squeeze(ranges(id1,id2,:)).*sin(angles'))
axis equal
title(gca,sprintf('id1:%d,id2:%d',id1,id2));
end