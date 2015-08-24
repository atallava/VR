function hf = vizHists2(h,hEst,xc1,xc2)
%VIZHISTS2 Viz two hists as subplots.
% 
% hf = VIZHISTS2(h,hEst,xc1,xc2)
% 
% h     - True histogram. Size [nXc1,nXc2].
% hEst  - Estimated histogram. Size [nXc1,nXc2].
% xc1        - Length nXc1. Histogram centers in dim1.
% xc2        - Length nXc2. Histogram centers in dim2.
% 
% hf    - Figure handle.

% single histogram
minSpan = 10;
span = max(round(size(h,1)/250),minSpan);
if isempty(hEst)
	hf = figure;
    
    % zooming in to imagesc
    [~,id] = max(h(:));
    [row,col] = ind2sub(size(h),id);
    left = max(col-span,1);
    right = min(col+span,size(h,2));
    up = max(row-span,1);
    down = min(row+span,size(h,1));
    imagesc(h(up:down,left:right))
	
    % labels
    xlabel('x2');
    % some tricks to get the right axis labels
    xt = get(gca,'XTick');
    vec = left:right; 
	set(gca,'XTickLabel',xc2(vec(xt)));
	ylabel('x1');
    yt = get(gca,'YTick');
    vec = up:down;
	set(gca,'YTickLabel',xc1(vec(yt)));
else
	hf = figure;
	subplot(2,1,1);
	% zooming in to imagesc
    [~,id] = max(h(:));
    [row,col] = ind2sub(size(h),id);
    left = max(col-span,1);
    right = min(col+span,size(h,2));
    up = max(row-span,1);
    down = min(row+span,size(h,1));
    imagesc(h(up:down,left:right))
	
    % labels
    xlabel('x2');
    % some tricks to get the right axis labels
    xt = get(gca,'XTick');
    vec = left:right; 
	set(gca,'XTickLabel',xc2(vec(xt)));
	ylabel('x1');
    yt = get(gca,'YTick');
    vec = up:down;
	set(gca,'YTickLabel',xc1(vec(yt)));
    title('true histogram');
	
    subplot(2,1,2);
	% zooming in to imagesc
    [~,id] = max(hEst(:));
    [row,col] = ind2sub(size(hEst),id);
    left = max(col-span,1);
    right = min(col+span,size(h,2));
    up = max(row-span,1);
    down = min(row+span,size(h,1));
    imagesc(h(up:down,left:right))
	
    % labels
    xlabel('x2');
    % some tricks to get the right axis labels
    xt = get(gca,'XTick');
    vec = left:right; 
	set(gca,'XTickLabel',xc2(vec(xt)));
	ylabel('x1');
    yt = get(gca,'YTick');
    vec = up:down;
	set(gca,'YTickLabel',xc1(vec(yt)));
	title('estimated histogram');
end
end

