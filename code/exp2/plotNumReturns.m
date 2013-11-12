load('processed_data2','num_returns');
for i = 1:6
    figure;
    scatter(1:length(num_returns{i}),num_returns{i},10);
    xlabel('orientation index');
    ylabel('number of returns from plane');
    title(gca,sprintf('range%d',i));
    saveas(gcf,sprintf('num_returns_%d.pdf',i));
end