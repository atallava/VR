function res = thetaCheck(th1,th2,tolerance)
%THETACHECK 
% 
% res = THETACHECK(th1,th2,tolerance)
% 
% th1       - In radian.
% th2       - "
% tolerance - "
% 
% res       - true if th1 and th2 are within tolerance

th1 = wrapTo2Pi(th1); 
th2 = wrapTo2Pi(th2); 
res = toleranceCheck(th1,th2,tolerance);
thmax = max(th1,th2);
thmin = min(th1,th2);
res = res | (thmin < wrapTo2Pi(thmax+tolerance));
end