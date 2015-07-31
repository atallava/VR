function str = yymmddDate()
%YYMMDDDATE Get date as string in yymmdd format.
% 
% str = YYMMDDDATE()
% 
% str - String.

cl = clock();
yy = num2str(cl(1));
yy = yy(3:4);
mm = padZero(num2str(cl(2)));
dd = padZero(num2str(cl(3)));
str = [yy mm dd];
end

function str = padZero(str)
if length(str) == 1
	str = ['0' str];
end
end