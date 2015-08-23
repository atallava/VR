function hf = vizHists2(h,hEst,xc1,xc2)
%VIZHISTS Viz two hists as subplots.
% 
% hf = VIZHISTS(h,hEst,xc)
% 
% h     - True histogram.
% hEst  - Estimated histogram.
% xc    - Bin centers.
% 
% hf    - Figure handle.

% single histogram
if isempty(hEst)
	hf = figure;
	bar3(h);
	xlabel('x2');
	set(gca,'XTickLabel',xc2);
	ylabel('xl');
	set(gca,'XTickLabel',xc1);
else
	hf = figure;
	subplot(1,2,1);
	bar3(h);
	xlabel('x2');
	set(gca,'XTickLabel',xc2);
	ylabel('xl');
	set(gca,'XTickLabel',xc1);
	title('true histogram');
	subplot(1,2,2);
	bar3(hEst);
	xlabel('x2');
	set(gca,'XTickLabel',xc2);
	ylabel('xl');
	set(gca,'XTickLabel',xc1);
	title('estimated histogram');
end
end

