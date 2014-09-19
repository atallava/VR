addpath ../
clc; clear all;
load processed_data_june6

poseId = 1; lineSet = {};
%% plot scan 
close all; clc;
clear('p1_*','p2_*','lines'); 
rangesMat = obsArrayByPose{poseId};
obsId = floor(rand*size(rangesMat,1));
ranges = rangesMat(obsId,:);
ri = rangeImage(struct('ranges',ranges));
ri.plotXvsY; title(sprintf('pose %d, observation %d',poseId,obsId));

%% append marked points to lineSet
vars = whos;
names = {vars.name};
temp1 = regexpi(names,'p1_'); temp1 = cellfun(@(x) ~isempty(x),temp1);
temp2 = regexpi(names,'p2_'); temp2 = cellfun(@(x) ~isempty(x),temp2);
p1ids = find(temp1); p2ids = find(temp2);
for i = 1:length(p1ids)
    pt1 = eval(names{p1ids(i)}); pt2 = eval(names{p2ids(i)});
    lines(i).p1 = pt1.Position'; lines(i).p2 = pt2.Position';
end
lineSet{end+1} = lines;
poseId = poseId+1;

%%
save('lineSet.mat','lineSet');