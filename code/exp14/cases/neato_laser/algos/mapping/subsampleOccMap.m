% create a finer-scale map from a coarse-scale map

cond = logical(exist('omBig','var'));
assert(cond,('omBig must exist in workspace.'));
cond = logical(exist('omSmall','var'));
assert(cond,('omSmall must exist in workspace.'));

%%
[xSmall,ySmall] = omSmall.rc2xy(1:size(omSmall,1),1:size(omSmall,2));
[rSmall2Big,cSmall2Big] = omBig.xy2rc(xSmall,ySmall);
idSmall2Big = sub2ind(size(omBig.logOddsGrid),rSmall2Big,cSmall2Big);
idOccBig = omBig.binaryGrid(:) == 1;
idOccSmall = ismember(idSmall2Big,idOccBig);
omSmall.binaryMap(idOccSmall) = 1;

