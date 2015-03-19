function hf = vizHists(h,hEst,xc)
%VIZHISTS 
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
title('true histogram');
subplot(2,1,2);
bar(xc,hEst);
title('estimated histogram');
end

