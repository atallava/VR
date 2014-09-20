function generatePCDs()
% generate PCDs of scans
% choice: {'real','baseline','sim','sim_pooled','sim_local_match'}
addpath(genpath('../'));
addpath ../../wanderer/
load application_test_data
load ../mats/processed_data_mar27.mat
load ../mats/roomLineMap


choices = {'real','baseline','sim','sim_pooled','sim_local_match'};
warning('off');        
laser = laserClass(struct());
nPoses = length(data);
nPatterns = length(patternSet);
nObs = 10;
fdir = '~/VR/code/pcl/scan_match/files/neato_data/application_scan_match';
count = 1;
countArray = [];
for ch = choices
    countArray(end+1) = count;
    choice = ch{1};
    switch choice
        case 'real'
            % nothing to be done
        case {'sim','baseline'}
            load('../mats/full_predictor_mar27_1','rsim');
            rsim.setMap(map);
        case 'sim_pooled'
            load('../mats/full_predictor_mar27_4','rsim');
            rsim.setMap(map);
        case 'sim_local_match'
            load('../mats/full_predictor_mar27_5','rsim');
            rsim.setMap(map);
    end
    fprintf('%s...\n',choice);
    t1 = tic();
    for i = 1:nPoses
        fprintf('Pose %d...\n',i);
        for j = 1:nPatterns
            if mod(j,10) == 0
                fprintf('Pattern %d...\n',j);
            end
            poseIn = data(i).pose+patternSet(:,j);
            for k = 1:nObs
                switch choice
                    case 'real'
                        ranges = data(i).ranges(k,:);
                    case 'baseline'
                        ranges = map.raycastNoisy(data(i).pose,laser.maxRange,laser.bearings);
                    case {'sim','sim_pooled','sim_local_match'}
                        ranges = rsim.simulate(data(i).pose);
                end
                ri = rangeImage(struct('ranges',ranges));
                pcd = pose2D.transformPoints(ri.getPtsHomogeneous,poseIn);
                pcd(3,:) = 0;
                fname = sprintf('%s/scan_%d.pcd',fdir,count);
                savepcd(fname,pcd);
                count = count+1;
            end
        end
    end
    fprintf('Generating pcds took %ds.\n',toc(t1));
end
warning('on');
save('pcd_file_data','countArray','nPoses','nPatterns','nObs');
end