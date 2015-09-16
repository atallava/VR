function hf = vizHistList(hList,xc,titles)
% hList     - cell of histograms
% xc    - Bin centers.
% 
% hf    - Figure handle.

% force axis limits
forceAxLim = 1;
xl = [0 4];
yl = [0 0.08];

n = length(hList);

if nargin < 3
    titles = cell(1,n);
    for i = 1:n
        titles{i} = sprintf('histogram %d',i);
    end
end

hf = figure;
for i = 1:n
    subplot(n,1,i);
    bar(xc,hList{i});
    xlabel('bins'); ylabel('prob');
    title(titles{i});
    if forceAxLim
        xlim(xl); ylim(yl);
    end
end

end

