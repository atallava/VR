optiLMarkerO = 'Marker-5'; % origin
optiLMarkerX = 'Marker-6'; % on x-axis
optiLMarkerY = 'Marker-2'; % on y-axis

% robotMarkerO = 'Rigid Body 2-Marker 1';
% robotMarkerX = 'Rigid Body 2-Marker 3';
% robotMarkerY = 'Rigid Body 2-Marker 2';
robotMarkerO = 'Marker-3';
robotMarkerX = 'Marker-4';
robotMarkerY = 'Marker-1';
robotRigidBodyId = [];

dateStr = yymmddDate();
fname = ['data/marker_names_' dateStr];
save(fname,'optiLMarkerO','optiLMarkerX','optiLMarkerY', ...
	'robotMarkerO','robotMarkerX','robotMarkerY');
	