function error = computeError(lx,ly,wall_id_r,wall_id_c,line)

ranges = arrayfun(@(i) getRangeToLine(deg2rad(i-1),line), wall_id_c);
ids = sub2ind(size(lx),wall_id_r,wall_id_c);
range_err = lx(ids).^2+ly(ids).^2; range_err = ranges-range_err.^0.5;

angles = unique(wall_id_c); %get unique angles in the data
error = cell(length(angles),2);
for i = 1:length(angles)
  error{i,1} = angles(i);
  angle_err_id = find(wall_id_c == angles(i)); %get the indices in range_err which correspond to angles(i)
  error{i,2} = range_err(angle_err_id);  
end

end



