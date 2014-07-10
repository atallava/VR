function [vec1,vec2] = splitVector(first,last,minLength,maxLength)
if last-first+1 <= maxLength
    vec1 = first;
    vec2 = last;
else
    vec1 = first:maxLength:last;
    r = last-vec1(end)+1;
    if r > 0 && r < minLength
        vec1(end) = last-minLength+1;
    end
    vec2 = [vec1(2:end)-1 last];
end
end

