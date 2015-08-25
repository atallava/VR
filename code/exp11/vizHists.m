function hf = vizHists(h,hEst,xc)
%VIZHISTS Viz two hists as subplots.
% 
% hf = VIZHISTS(h,hEst,xc)
% 
% h     - True histogram.
% hEst  - Estimated histogram.
% xc    - Bin centers.
% 
% hf    - Figure handle.

hf = figure;
subplot(2,1,1);
bar(xc,h);
xlabel('bins'); ylabel('probability');
yl = ylim;
title('true histogram');
subplot(2,1,2);
bar(xc,hEst);
% ylim(yl);
xlabel('bins'); ylabel('probability');
title('estimated histogram');
end

