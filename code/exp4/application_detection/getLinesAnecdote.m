function [lines,linesInfo] = getLinesAnecdote(ri,targetLength,lineCandidateAlgo,plot_option,showMsgs)
% ri is a rangeImage object

if nargin < 4
    plot_option = 0;

end
if nargin < 4 || nargin < 5
	showMsgs = 0;
end

linesInfo = {};
lines = struct('p1',{},'p2',{});
nLines = 0;
for i = 1:ri.nPix
    res = lineCandidateAlgo(ri,i,targetLength,showMsgs);
    if isempty(res)
        continue;
    end
    nLines = nLines+1;
    linesInfo{nLines} = res;
end

length_pad = 0.1;
longLinesInfo = {};
for i = 1:ri.nPix
    res = lineCandidateAlgo(ri,i,targetLength+length_pad,false);
    if isempty(res)
        continue;
    end
    longLinesInfo{end+1} = res;
end
linesInfo = removeLongerLines(linesInfo,longLinesInfo,ri);

nLines = length(linesInfo);
if nLines == 0
    lines = struct('p1',{},'p2',{});
    return;
end
lines = lineInfo2lineStruct(ri,linesInfo);

if plot_option
    ri.plotXvsY; 
    hold on;
    for line = lines
        plot([line.p1(1) line.p2(1)],[line.p1(2) line.p2(2)],'g','LineWidth',2);
    end
end

end
