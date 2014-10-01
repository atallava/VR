t1 = tic();
x = 3;
for i = 1:30
    load('full_predictor_sep6_1');
end
save('dummy_3','x');
toc(t1)