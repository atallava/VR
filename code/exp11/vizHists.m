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

% force axis limits
forceAxLim = 0;
xl = [1 2];
yl = [0 0.5];

hf = figure;
subplot(2,1,1);
bar(xc,h);
xlabel('bins'); ylabel('probability');
title('true histogram');
if forceAxLim
    xlim(xl); ylim(yl); 
end

subplot(2,1,2);
bar(xc,hEst);
xlabel('bins'); ylabel('probability');
title('estimated histogram');
if forceAxLim
    xlim(xl); ylim(yl); 
end

end

