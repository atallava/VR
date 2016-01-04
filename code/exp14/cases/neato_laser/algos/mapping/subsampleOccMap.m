% create finer map from coarse map

cond = logical(exist('omBig','var'));
assert(cond,('omBig must exist in workspace.'));
cond = logical(exist('omSmall','var'));
assert(cond,('omSmall must exist in workspace.'));

%% binary map
[xSmall,ySmall] = omSmall.rc2xy(1:size(omSmall.logOddsGrid,1),1:size(omSmall.logOddsGrid,2));
[rSmall2Big,cSmall2Big] = omBig.xy2rc(xSmall,ySmall);
% takes a cell in omSmall to a cell in omBig
idSmall2Big = sub2ind(size(omBig.logOddsGrid),rSmall2Big,cSmall2Big); 
idOccBig = omBig.binaryGrid(:) == 1;
idOccSmall = ismember(idSmall2Big,idOccBig);
omSmall.binaryMap(idOccSmall) = 1;

%% log odds map
vec = omBig.logOddsGrid(idSmall2Big);
omSmall.logOddsGrid = reshape(vec,size(omSmall.logOddsGrid));
