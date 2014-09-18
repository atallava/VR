function flag = allCrazy(lzr)
% sometimes all readings become something like 0.08. pick those cases
flag = zeros(1,length(lzr.log));
for i = 1:length(lzr.log)
    if length(unique(lzr.log(i).ranges)) == 1
        flag(i) = unique(lzr.log(i).ranges);
    end
end
end