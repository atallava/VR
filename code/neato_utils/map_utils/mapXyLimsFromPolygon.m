function xyLims = mapXyLimsFromPolygon(varargin)
%MAPXYLIMSFROMPOLYGON 
% 
% xyLims = MAPXYLIMSFROMPOLYGON(varargin)
% xyLims = MAPXYLIMSFROMPOLYGON(polygon)
% xyLims = MAPXYLIMSFROMPOLYGON(polygon,padding)
% 
% polygon - Struct with fields ('xv','yv'). Each vector of points.
% padding - Scalar, in same units as polygon.
% 
% xyLims  - [xMin xMax; yMin yMax].

polygon = varargin{1};
if length(varargin) == 2
    padding = varargin{2};
else
    padding = 0.1;
end
xMax = max(polygon.xv)+padding;
xMin = min(polygon.xv)-padding;
yMax = max(polygon.yv)+padding;
yMin = min(polygon.yv)-padding;
xyLims = [xMin xMax; yMin yMax];
end