load lineSet
lineL = 0.61; 
for i = 1%:length(lineSet)
    lines = lineSet{i};
    clear newLines;
    for j = 1:length(lines)
        newLine = fixLineLength(lines(j),lineL);
        newLines(j) = newLine;
    end
    lineSet{i} = newLines;
end