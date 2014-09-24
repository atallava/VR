function [h1,h2] = generatePlots(perf,perfReal)
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

h1 = figure();
hc1 = plot(rs,ps,'ro','linewidth',2); hold on;
fnplt(cscvn([rs; ps]),'r',2); 
hc2 = plot(rr,pr,'bo','linewidth',2);
fnplt(cscvn([rr; pr]),'b',2); hold off; 
lVec = [-0.01 0.6];
axis equal; xlim(lVec); ylim(lVec);
xlabel('recall'); ylabel('precision'); 
legend([hc1 hc2],{'simulated scans','real scans'});

h2 = figure();
plot(1:nIter,f1s,'r-o','linewidth',2); hold on;
plot(1:nIter,f1r,'b-o','linewidth',2); hold off; 
ylim([0 0.5]);
xlabel('Algorithm iteration.'); ylabel('F1 score'); 
legend('simulated scans','real scans');
end