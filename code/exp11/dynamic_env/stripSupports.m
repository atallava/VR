wallOffset = 0.5;
stripWidth = 1;

pts1 = [-2.5+wallOffset -2.5; -2.5+wallOffset+stripWidth -2.5; ...
    -2.5+wallOffset+stripWidth 2.5; -2.5+wallOffset 2.5; -2.5+wallOffset -2.5];
support1.xv = pts1(:,1); support1.yv = pts1(:,2);

pts2 = [2.5-wallOffset -2.5; 2.5-wallOffset-stripWidth -2.5; ...
    2.5-wallOffset-stripWidth 2.5; 2.5-wallOffset 2.5; 2.5-wallOffset -2.5];
support2.xv = pts2(:,1); support2.yv = pts2(:,2);

supports = [support1 support2];

save('../data/straight_corridor_dynamic_supports','supports');