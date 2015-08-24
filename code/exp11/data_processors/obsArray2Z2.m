function Z = obsArray2Z2(obsArray,poseIds,bearingGroupIds)
    
    N = length(poseIds);
    [G,g] = size(bearingGroupIds);
    Z = cell(1,N*G);
    count = 1;
    for i = 1:N
        poseId = poseIds(i);
        for j = 1:G
            ranges1 = obsArray{poseId,bearingGroupIds(i,1)};
            ranges2 = obsArray{poseId,bearingGroupIds(i,2)};
            M = min(length(ranges1),length(ranges2));
            z = zeros(2,M);
            z(1,:) = ranges1(1:M); 
            z(2,:) = ranges2(1:M);
            Z{count} = z;
            count = count+1;
        end
    end
    
end

