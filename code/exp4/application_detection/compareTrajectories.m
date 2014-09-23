%
dr = load('scans_real');
db = load('scans_baseline');
ds = load('scans_sim_sep6_1');
load target_lines_by_conf

targetLength = 0.61;

%% Baseline
% on basline
[ndb,ncb,ntb] = getPR(db.scans,targetLength,targetLinesByConf,@lineCandBaseline);
pb = sum(ncb)/sum(ndb);
rb = sum(ncb)/sum(ntb);

% on real
[ndr,ncr,ntr] = getPR(dr.scans,targetLength,targetLinesByConf,@lineCandBaseline);
pr = sum(ncr)/sum(ndr);
rr = sum(ncr)/sum(ntr);
