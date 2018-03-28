function [hfig1,hfig2] = generatePlots(perf,perfReal)
%GENERATEPLOTS 
% 
% [h1,h2] = GENERATEPLOTS(perf,perfReal)
% 
% perf     - Cell with structs of sim performance.
% perfReal - Cell with structs of real performance.
% 
% h1       - Handle to PR trajectory figure.
% h2       - Handle to F1 figure.

nIter = length(perf);
for i = 1:nIter
    rs(i) = perf{i}.r;
    ps(i) = perf{i}.p;
    rr(i) = perfReal{i}.r;
    pr(i) = perfReal{i}.p;
    f1s(i) = computeF1(perf{i});
    f1r(i) = computeF1(perfReal{i});
end

simCol = [1 0 0];
realCol = [0 0 1];
markerSize = 500;

% precision vs recall
hfig1 = figure(); hold on;

hc1 = scatter(rs, ps, '.', ...
    'markerFaceColor', simCol, 'markerEdgeColor', simCol, 'sizeData', markerSize);
pts = fnplt(cscvn([rs; ps])); 
plot(pts(1,:),pts(2,:),'color',simCol,'linewidth',3);
hc2 = scatter(rr, pr, '.', ...
    'markerFaceColor', realCol, 'markerEdgeColor', realCol, 'sizeData', markerSize);
pts = fnplt(cscvn([rr; pr]));
plot(pts(1,:),pts(2,:),'color',realCol,'linewidth',3);

lVec = [-0.01 0.6];
axis equal; xlim(lVec); ylim(lVec);
xlabel('recall'); ylabel('precision'); 
% legend([hc1 hc2],{'simulated scans','real scans'});
set(gca, 'fontsize', 15);

% f1 vs dev iter
hfig2 = figure(); hold on;
plot(1:nIter,f1s, 'color',simCol,'linewidth',3); 
scatter(1:nIter, f1s, '.', ...
    'markerFaceColor', simCol, 'markerEdgeColor', simCol, 'sizeData', markerSize);

plot(1:nIter, f1r, 'color', realCol, 'linewidth', 3);
scatter(1:nIter, f1r, '.', ...
    'markerFaceColor', realCol, 'markerEdgeColor', realCol, 'sizeData', markerSize);

ylim([0 0.5]);
xlabel('development iteration'); ylabel('F1 score'); 
% legend('simulated scans','real scans');
set(gca, 'fontsize', 15);
end