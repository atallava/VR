function x2 = smoothDiff(x1,windowSize)
% x2 is smoothed difference in x1
if windowSize == 1
	x2 = x1(2:end)-x1(1:end-1);
	return;
end
x2 = zeros(1,length(x1)-2*windowSize);
for i = (windowSize+1):(length(x1)-windowSize)
	leftWindow = mean(x1(i-windowSize:i-1));
	rightWindow = mean(x1(i+1:i+windowSize));
	x2(i-windowSize) = rightWindow-leftWindow;
end
end