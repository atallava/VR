% initialize
if ~exist('rob','var')
    error('ROB MUST EXIST IN WORKSPACE');
end
if ~exist('rstate','var')
    error('RSTATE MUST EXIST IN WORKSPACE');
end
% % laser must be on
% if ~isfield(rob.laser.data,'header')
%     error('LASER MUST BE ON!');
% end
% % map must be present in environment
% if ~exist('map','var')
%     error('MAP MUST EXIST IN WORKSPACE');
% end

