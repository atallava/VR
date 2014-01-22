function lines = getLinesSimple(rangeImage_obj,target_length,display_option)
% searching for line of size target_length
% lines is a cell array of [error,th,num,middle,left,right]

lines = getRawLines(rangeImage_obj,target_length);

% remove line segments which potentially belong to longer segments
% not very fast
length_pad = 0.1;
long_lines = getRawLines(rangeImage_obj,target_length+length_pad);

% if this fraction or greater of a line segements in lines overlaps a
% segment in long_lines, consider for removal
overlap_limit = 0.6;
% if theta of overlapping segments are this close together, remove from
% lines
th_tolerance = deg2rad(2.5);
remove_lines = [];
for i = 1:length(lines)
    th1 = lines{i}(2);
    l1 = lines{i}(5);
    r1 = lines{i}(6);
    if r1 < l1
        ids1 = [l1:rangeImage_obj.npix,1:r1];
    else
        ids1 = l1:r1;
    end  
    for j = 1:length(long_lines)
        th2 = long_lines{j}(2);
        if toleranceCheck(th1,th2,th_tolerance)
            l2 = long_lines{j}(5);
            r2 = long_lines{j}(6);
            if r2 < l2
                ids2 = [l2:rangeImage_obj.npix,1:r2];
            else
                ids2 = l2:r2;
            end
            overlap_fraction = length(intersect(ids1,ids2))/length(ids1);
            if overlap_fraction >= overlap_limit
                if lines{i}(4) == 181
                    long_lines{j}(4)
                end
                remove_lines(end+1) = i;
                break;
            end
        end
    end
end

lines(remove_lines) = [];

lines = mergeLines(lines);


if display_option
    numlines = length(lines);
    middles = arrayfun(@(x) lines{x}(4),1:numlines);

    hf = rangeImage_obj.plotXvsY(rangeImage_obj.maxUsefulRange);
    figure(hf);
    hold on
    for i = 1:numlines
        middle = lines{i}(4);
        th = lines{i}(2);
        xmiddle = rangeImage_obj.xArray(middle);
        ymiddle = rangeImage_obj.yArray(middle);
        p1 = [xmiddle+target_length*0.5*cos(th) ymiddle+target_length*0.5*sin(th)];
        p2 = [xmiddle-target_length*0.5*cos(th) ymiddle-target_length*0.5*sin(th)];
        scatter(xmiddle,ymiddle,50,'r');
        plot([p1(1) p2(1)],[p1(2) p2(2)],'g');
    end
    hold off
    dcm_obj = datacursormode(hf);
    set(dcm_obj,'UpdateFcn',@updateWithId);
end
    function txt = updateWithId(~,event_obj)
        pos = get(event_obj,'Position');
        x_coord = pos(1); y_coord = pos(2);
        x_id = find(rangeImage_obj.xArray == x_coord);
        y_id = find(rangeImage_obj.yArray == y_coord);
        id = intersect(x_id,y_id);
        txt = {['x: ',num2str(x_coord)],...
            ['y: ',num2str(y_coord)],...
            ['id: ',num2str(id)]};
    end
end


