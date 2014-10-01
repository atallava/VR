function [t,d] = statsOverRflParams(choice,ids)
% choice is 'real','sim','baseline'

t = zeros(1,4);
d = zeros(1,3);

for i = 1:4
   f(i) = load([choice '_reg_filters_' int2str(i)]); 
end

if nargin < 2
    ids = 1:length(f(i).rflArray);
end

for i = 1:4
    for j = ids
        t(i) = t(i)+f(i).rflArray(j).avgTimeToMatch;
        if i > 1
            d(i-1) = d(i-1)+directTrajMetric(f(i).rflArray(j),f(1).rflArray(j));
        end
    end
end

t = t/length(ids);
d = d/length(ids);

end

