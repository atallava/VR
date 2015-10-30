load sample_hist_pred_ascension

%%
hList = {hGt hDReg hPReg};
xl = [-1 20];
yl = [0 0.1];
ylabels = {'$h$','$\hat{h}$','$\hat{h}$'};
titles = {'true histogram','NP-Reg','P-Reg'};

fs = 15;
for i = 1:3
    subplot(3,1,i);
    bar(xc,hList{i});
    xlim(xl); ylim(yl);
    xlabel('z','fontsize',fs); ylabel(ylabels{i},'interpreter','latex','fontsize',fs);
    title(titles{i});
end

