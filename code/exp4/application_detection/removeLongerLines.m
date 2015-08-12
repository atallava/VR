function linesInfo = removeLongerLines(linesInfo,longLinesInfo,ri)
% ri is a rangeImage object.
% linesInfo is a set of candidates found for target length.
% longLinesInfo is a set of candidates for greater than target length.
% remove lines which are actually longer lines.

% if this fraction or greater of a line segements in linesInfo overlaps a
% segment in longLinesInfo, consider for removal
overlap_limit = 0.8;
% if theta of overlapping segments are this close together, remove from
% linesInfo. theta check is off for now.
th_tolerance = deg2rad(2.5);
remove_lines = [];
for i = 1:length(linesInfo)
    th1 = linesInfo{i}.th;
    ids1 = circArray.getCircSection(linesInfo{i}.left,linesInfo{i}.right,ri.nPix);
    for j = 1:length(longLinesInfo)
        th2 = longLinesInfo{j}.th;
        if toleranceCheck(th1,th2,th_tolerance)
            ids2 = circArray.getCircSection(longLinesInfo{j}.left,longLinesInfo{j}.right,ri.nPix);
            overlap_fraction = length(intersect(ids1,ids2))/length(ids1);
            if overlap_fraction >= overlap_limit
                remove_lines(end+1) = i;
                break;
            end
        end
    end
end
linesInfo(remove_lines) = [];

end

