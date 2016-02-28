% load ../data/npreg_exp/pf_res_npreg_exp_1_trial_6.mat
load ../data/pf_npreg_res;

%% environment
% map in black
% get walls
hfig1 = figure;
hold on;
desiredLinewidth = 7;
walls = map.objects();
colorWalls = [1 1 1]*0;
for i = 1:length(walls)
    lines = walls(i).lines;
    plot(lines(:,1),lines(:,2),'color',colorWalls,'linewidth',desiredLinewidth);
end

% padding
padding = [-0.5 0.5];
desiredXlim = xlim+padding;
desiredYlim = ylim+padding;
xlim(desiredXlim);
ylim(desiredYlim);

xlabel('x (m)');
% axes font size
fs = 15;
set(gca,'FontSize',fs);

box on;
xlabel('x (m)','fontsize',fs); 
ylabel('y (m)','fontsize',fs);

%% true trajectory
plot(poseHistory(1,:),poseHistory(2,:),'b--','linewidth',1);

%% a few snapshots of the particle filter
nSnapshots = 4;
nParticlesInSnapshot = 20;
ids = floor(linspace(1,length(particlesLog),nSnapshots));

scatterPointArea = 20;
colorParticles = [0 1 0]*0.7;
for i = 1:nSnapshots
    poses = [particlesLog{ids(i)}.pose];
    poses = datasample(poses',nParticlesInSnapshot);
    poses = poses';
    scatter(poses(1,:),poses(2,:),scatterPointArea,'filled','MarkerFaceColor',colorParticles);
end