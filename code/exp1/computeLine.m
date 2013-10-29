load processed_data.mat
%{
[avgdist,cset,line] = lineFitRANSAC([lx(ids) ly(ids)],100,2,0.01);
save('processed_data.mat','line','-append');
fprintf('average distance: %f\n',avgdist);
fprintf('fraction of points in consensus set: %f\n', numel(cset)/numel(ids));
%}
hf = figure;
hs = scatter(lx(ids),ly(ids),5,'r');
axis equal
hold on
ha = gca;
xlim = get(gca,'XLim'); ylim = get(gca,'YLim');
pts_line = [(-line(3)-line(2)*ylim(1))/line(1) (-line(3)-line(2)*ylim(2))/line(1); ylim(1) ylim(2)];
hline = plot(pts_line(1,:),pts_line(2,:),'b--');
set(gca,'XLim',xlim,'YLim',ylim);