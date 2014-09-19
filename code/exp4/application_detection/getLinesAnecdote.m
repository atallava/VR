function [lines,linesInfo] = getLinesAnecdote(ri,target_length,lineCandidateAlgo,plot_option)
% ri is a rangeImage object

if nargin < 4
    plot_option = 0;
end

linesInfo = {};
lines = struct('p1',{},'p2',{});
nLines = 0;
for i = 1:ri.nPix
    res = lineCandidateAlgo(ri,i,target_length,0);
    if isempty(res)
        continue;
    end
    nLines = nLines+1;
    linesInfo{nLines} = res;
end

if nLines == 0
    return;
end
    
for i = 1:nLines
    p1id = linesInfo{i}.left; 
    p2id = linesInfo{i}.right;
    lines(i).p1 = [ri.xArray(p1id); ri.yArray(p1id)]; 
    lines(i).p2 = [ri.xArray(p2id); ri.yArray(p2id)];
end

if plot_option
    ri.plotXvsY; 
    hold on;
    for line = lines
        plot([line.p1(1) line.p2(1)],[line.p1(2) line.p2(2)],'g','LineWidth',3);
    end
end

end
