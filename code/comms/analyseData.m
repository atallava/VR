load data_static_enc_comm_milli_310115

%%
%h = encHistArray(1);
h = lzrHistArray(1);
tRob = h.tArray;
tLocal = h.tLocalArray;
dt = max(tRob-tLocal);
tRob = tRob-dt;

ids = 1:20;
tRob = tRob(ids); tLocal = tLocal(ids);

%% 
figure; hold on;
plot(tRob,2*ones(size(tRob)),'b.');
plot(tLocal,1*ones(size(tLocal)),'r.');
for i = 1:length(tRob)
	plot([tRob(i) tLocal(i)],[2 1]);
end
ylim([0 3]);
xlim(xlim+[-0.1 0.1]);

%%
[ivlPub1,ivlSub1,delays1] = getTimeIntervals('data_static_enc_comm_milli_310115');
[ivlPub2,ivlSub2,delays2] = getTimeIntervals('data_static_enc_comm_laser_on_milli_310115');
