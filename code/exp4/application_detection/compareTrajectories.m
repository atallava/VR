% Initialize
clearAll;
dr = load('scans_real');
db = load('scans_baseline');
ds = load('scans_sim_sep6_1');
load target_lines_by_conf

targetLength = 0.61;
blog = 'baseline_perf_log';
slog = 'sim_perf_log';

%% Baseline
% on basline
clc;
t1 = tic();
[resBB.nd,resBB.nc,resBB.nt] = getPR(db.scans,targetLength,targetLinesByConf,@lineCandBaseline);
resBB.p = sum(resBB.nc)/sum(resBB.nd);
resBB.r = sum(resBB.nc)/sum(resBB.nt);

% on real
[resBR.nd,resBR.nc,resBR.nt] = getPR(dr.scans,targetLength,targetLinesByConf,@lineCandBaseline);
resBR.p = sum(resBR.nc)/sum(resBR.nd);
resBR.r = sum(resBR.nc)/sum(resBR.nt);
fprintf('Computation took %.2fs.\n',toc(t1));

%% Sim
% on sim
clc;
t1 = tic();
[resSS.nd,resSS.nc,resSS.nt] = getPR(ds.scans,targetLength,targetLinesByConf,@lineCandSim);
resSS.p = sum(resSS.nc)/sum(resSS.nd);
resSS.r = sum(resSS.nc)/sum(resSS.nt);

% on real
[resSR.nd,resSR.nc,resSR.nt] = getPR(dr.scans,targetLength,targetLinesByConf,@lineCandSim);
resSR.p = sum(resSR.nc)/sum(resSR.nd);
resSR.r = sum(resSR.nc)/sum(resSR.nt);
fprintf('Computation took %.2fs.\n',toc(t1));

