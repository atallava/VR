% pretty print stats for thesis

%% load
choices = {'real','sim','baseline'};

t = cell(1,length(choices));
d = cell(1,length(choices));

for i = 1:length(choices)
    [t{i},d{i}] = statsOverRflParams(choices{i});
end

%% viz compute times
hfig = figure; hold on;
refIters = [10 30 50 100];
lineWidth = 3;
legendStr = {'real','our approach','baseline'};

plot(refIters, fliplr(t{1}), ...
    '.-', 'lineWidth', lineWidth);

plot(refIters, fliplr(t{2}), ...
    '.-', 'lineWidth', lineWidth);

plot(refIters, fliplr(t{3}), ...
    '.-', 'lineWidth', lineWidth);

xlabel('refining iterations'); ylabel('mean scan match time');
legend(legendStr);

fontSize = 15;
set(gca, 'fontsize', fontSize);

%% viz filter errors
hfig = figure; hold on;
refIters = [10 30 50];
lineWidth = 3;
legendStr = {'real','our approach','baseline'};

plot(refIters, fliplr(d{1}), ...
    '.-', 'lineWidth', lineWidth);

plot(refIters, fliplr(d{2}), ...
    '.-', 'lineWidth', lineWidth);

plot(refIters, fliplr(d{3}), ...
    '.-', 'lineWidth', lineWidth);

xlabel('refining iterations'); ylabel('objective J');
legend(legendStr);

fontSize = 15;
set(gca, 'fontsize', fontSize);
