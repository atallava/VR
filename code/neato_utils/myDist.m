function r2 = myDist(p,v,w)
% v,w are 2 x 1
% p is 2 x n

r2 = zeros(1,size(p,2));
l2 = sum((v-w).^2);
vec1 = bsxfun(@minus,p,v);
vec2 = w-v;
vec3 = bsxfun(@times,vec1,vec2);
vec3 = sum(vec3,1)/l2;

flag1 = vec3 < 0;
if any(flag1)
    vec4 = sum(vec1.^2,1);
    r2(flag1) = vec4(flag1);
end

flag2 = vec3 > 1;
if any(flag2)
    vec5 = bsxfun(@minus,p,w);
    vec5 = sum(vec5.^2,1);
    r2(flag2) = vec5(flag2);
end

flag3 = ~(flag1 | flag2);
if any(flag3)
    y1 = bsxfun(@times,ones(2,size(p,2)),vec2);
    y1 = bsxfun(@times,y1,vec3);
    y1 = bsxfun(@plus,v,y1);
    y2 = p-y1; y2 = sum(y2.^2);
    r2(flag3) = y2(flag3);
end
end

