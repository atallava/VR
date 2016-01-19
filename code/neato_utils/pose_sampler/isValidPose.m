function flag = isValidPose(map,support,bBox)
    % is bounding box a valid pose on the map
    
    % within support
    flag = true;
    in = inpolygon(bBox.xv,bBox.yv,support.xv,support.yv);
    inSupport = all(in);
    if ~inSupport
        flag = false;
        return;
    end
        
    % not in collision with other objects
    for i = 1:length(map.objects)
        object = map.objects(i);
        flag1 = all(ismember(object.lines(:,1),support.xv));
        flag2 = all(ismember(object.lines(:,2),support.yv));
        % object is part of support
        if flag1 && flag2
            continue;
        end
        [xi,yi] = polyxpoly(bBox.xv,bBox.yv,object.lines(:,1),object.lines(:,2));
        outObject = isempty(xi);
%         in1 = inpolygon(bBox.xv,bBox.yv,object.lines(:,1),object.lines(:,2));
%         in2 = inpolygon(object.lines(:,1),object.lines(:,2),bBox.xv,bBox.yv);
%         outObject = ~any([in1 in2']);        
        if ~outObject
            flag = false;
            break;
        end
    end
end