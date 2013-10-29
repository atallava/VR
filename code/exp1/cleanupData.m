load('range_data.mat','range_data');
th = deg2rad(0:359);
lx = bsxfun(@times,range_data,cos(th));
ly = bsxfun(@times,range_data,sin(th));

xmin = 0.2; xmax = 0.4;
ymin = -0.3; ymax = 1.0;
[wall_id_r, wall_id_c] = find(lx >= xmin & lx <= xmax & ly >= ymin);
ids = sub2ind(size(lx),wall_id_r,wall_id_c);
save('processed_data.mat','lx','ly','wall_id_r','wall_id_c','ids');

%{
data_id = 13; %arbitrary, just testing
wall_ids = find(lx(data_id,:) >= xmin & lx(data_id,:) <= xmax & ly(data_id,:) >= ymin);
if ~exist('hs')
  hs = scatter(lx(data_id,wall_ids),ly(data_id,wall_ids),5,'r');
else
  set(hs,'XData',lx(data_id,wall_ids),'YData',ly(data_id,wall_ids))
end
axis([xmin xmax ymin ymax]);
%}