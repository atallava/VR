load('range_data.mat','range_data');
th = deg2rad(0:359);
lx = bsxfun(@times,range_data,cos(th));
ly = bsxfun(@times,range_data,sin(th));

xmin = 0.2; xmax = 0.4;
ymin = -0.3; ymax = 1.0;
[wall_id_r, wall_id_c] = find(lx >= xmin & lx <= xmax & ly >= ymin);
ids = sub2ind(size(lx),wall_id_r,wall_id_c);
save('processed_data.mat','lx','ly','wall_id_r','wall_id_c','ids');

