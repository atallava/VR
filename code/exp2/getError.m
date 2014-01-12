function error = getError(ranges, j, plot_option)
%ranges is a full set of readings for a pose of the robot, it is MxNx360
%error is a matrix of form [return_id true_range angle_of_incidence j...
%range_error];
%TODO: explain what return_cols is

load('processed_data1','box','theta','angles','dpose');
%get interest box
int_box = getBox(box{j},dpose);

%which measurements to plot at
plot_ids = 0:50:400; plot_ids(1) = 1;

t_line = 0.2; %threshold for belonging to line
len_line = 2; %length of board to consider

M = size(ranges,1); %number of orientations
N = size(ranges,2); %number of measurements at a particular orientation
num_returns = zeros(1,M); %number of returns from wood
lines = zeros(3,M); %best fit lines
error = zeros(360*N,5);
error = error;
error_id = 1;
for i = 1:M
    if mod(i,100) == 0
        fprintf('orientation %d\n',i);
    end
    rx = reshape(ranges(i,:,:),N*360,1).*cos(reshape(repmat(angles,N,1),N*360,1));
    ry = reshape(ranges(i,:,:),N*360,1).*sin(reshape(repmat(angles,N,1),N*360,1));
    %massive array of coordinates of all Nx360 returns
    coords = [rx ry]';
    return_cols = 1:size(coords,2); 
    
    %estimate how much robot has rotated
    th = deg2rad(theta(j)*(i-1));
    R = getRotMat(th);
    %rotate world
    coords = R*coords;
    %find which points lie in the interest box
    box_ids = find(coords(1,:) > max(int_box(1,1),0) & coords(1,:) <= int_box(2,1) & coords(2,:) >= int_box(1,2) & coords(2,:) <= int_box(3,2)); %don't want to include origin, which will have many returns
    coords = coords(:,box_ids); 
    return_cols = return_cols(box_ids); 
    [~, ~, lines(:,i)] = lineFitRANSAC(coords',100,2,0.01); 
    
    
    %find which points are part of line
    dists = distToLine(coords',lines(:,i)); 
    %line_ids1 = 1:length(box_ids); %if you want to see all pts in box_ids
    line_ids1 = find(dists <= t_line);
    coords = coords(:,line_ids1); 
    return_cols = return_cols(line_ids1); 
        
    %reject random blobs on line
    alpha = atanLine(lines(1,i),lines(2,i));
    ysearch = linspace(int_box(1,2),int_box(4,2)-len_line*sin(alpha));
    yrange = [ysearch; ysearch+2*sin(alpha)];
    %number of points in a len_line-length window at various positions...
    %along the least-squares line
    pts_yrange = arrayfun(@(i) find(coords(2,:) >= yrange(1,i) & coords(2,:) <= yrange(2,i)), 1:size(yrange,2),'UniformOutput',false);
    npts_yrange = cellfun(@(x) length(x),pts_yrange);
    %find that window with maximum points in it
    [~,max_npts_id] = max(npts_yrange);
    %line_ids2 = 1:length(line_ids1) %if you want to see all pts in...
    %... line_ids1
    line_ids2 = pts_yrange{max_npts_id}; 
    coords = coords(:,line_ids2); 
    return_cols = return_cols(line_ids2); 
       
    num_returns(i) = length(line_ids2);
    
    %laser return index
    [~, return_px] = ind2sub([N 360], return_cols);
    rotated_col_angles = mod(deg2rad((return_px-1))+th,2*pi);
    true_ranges = arrayfun(@(x) getRangeToLine(x,lines(:,i)), rotated_col_angles);
    %truex = true_ranges.*cos(rotated_col_angles); truey = true_ranges.*sin(rotated_col_angles);
    %return range error
    return_ranges = arrayfun(@(x) norm(coords(:,x)),1:size(coords,2),'uni',0); 
    return_ranges = cell2mat(return_ranges);
    return_error = true_ranges-return_ranges;
    %angle at which ray strikes board
    return_angle_incidence = atan2(coords(2,:),coords(1,:))+pi/2-alpha; 

    error(error_id:error_id+num_returns(i)-1,:) = [return_px' true_ranges' return_angle_incidence' j*ones(numel(return_px),1) return_error'];
    error_id = error_id+num_returns(i);
    %}
    if plot_option ~= 0
        %plot to check
        if any(plot_ids == i)
            scatter(coords(1,box_ids(line_ids1(line_ids2))),coords(2,box_ids(line_ids1(line_ids2))));
            hold on;
            box_pts = [int_box; int_box(1,:)]; %just to draw a closed int_box
            %draw interest box_ids
            plot(box_pts(:,1),box_pts(:,2),'r');
            axis equal;
            title(gca,sprintf('%d',i));
            xlim = get(gca,'XLim'); ylim = get(gca,'YLim');
            pts_line = [(-lines(3,i)-lines(2,i)*ylim(1))/lines(1,i) (-lines(3,i)-lines(2,i)*ylim(2))/lines(1,i); ylim(1) ylim(2)];
            plot(pts_line(1,:),pts_line(2,:),'g--');
            set(gca,'XLim',xlim,'YLim',ylim);
            waitforbuttonpress;
            close(gcf);
        end
    end
end

error(sum(error,2) == 0,:) = [];
end