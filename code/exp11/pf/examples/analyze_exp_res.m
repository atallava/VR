% stats for running pf experiments

% fnamePre = '../data/npreg_exp/pf_res_npreg';
fnamePre = '../data/thrun_exp/pf_res_thrun';

nExp = 4;
nTrialsList = [30 30 30 30];
meanErrList = zeros(1,nExp);
stdErrList = zeros(1,nExp);

for i = 1:nExp
    nTrials = nTrialsList(i);
    % file names
    fnames = cell(1,nTrials);
    for j = 1:nTrials
        fnames{j} = sprintf('%s_exp_%d_trial_%d',fnamePre,i,j);
    end
    [meanErr,stdErr] = calcAvgTrajError(fnames);
    fprintf('Experiment %d.\n',i);
    fprintf('mean err: %.4f, std err: %.4f\n',meanErr,stdErr);
    meanErrList(i) = meanErr;
    stdErrList(i) = stdErr;
end