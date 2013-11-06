function [ds,dth] = degTurn(rob)
%turn a neato 1 degree counter-clockwise
%report back the actual dislacement angle turned from encoder data
v = 0.0008;
wheel_base = 0.248;
T = deg2rad(1)*wheel_base/(2*v);
l_old = rob.encoders.data.left; r_old = rob.encoders.data.right;
t1 = tic;
while true
  sendVelocity(rob,-v,v);
  if toc(t1) >= T
    sendVelocity(rob,0.0,0.0);
    break;
  end
  pause(0.001);
end
%pause before getting final encoder data
pause(0.125);
dl = rob.encoders.data.left-l_old; dr = rob.encoders.data.right-r_old;
ds = (dl+dr)*0.5; dth = (dr-dl)*1e-3/wheel_base;
end