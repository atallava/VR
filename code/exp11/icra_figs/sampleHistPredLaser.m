load sample_hist_pred_laser

%%
hId = 12;
hList = {hGt(hId,:) hDReg(hId,:) hPReg(hId,:)};
xl = [2 2.2];
yl = [0 0.3];
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

