load data_neato-laser_exp11-sensor-modeling-perf-ntrain_140906_1
% load data/data_sim-laser-gencal_exp11-sensor-modeling-perf-ntrain_150821_2.mat

%%
fs = 15;
lw = 2;
hf = figure; hold on;
errorbar(NTrainSetPReg,mean(errPReg,2),std(errPReg,0,2),'.-r','linewidth',lw);
hold on;
errorbar(NTrainSetDReg,mean(errDReg,2),std(errDReg,0,2),'.-b','linewidth',lw);
xlabel('N','fontsize',fs);
ylabel('$\hat{R}$','interpreter','latex','fontsize',fs);
legend('P-Reg','D-Reg');
box on; grid on;
