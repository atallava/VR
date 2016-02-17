function stateOut = flatSim(stateIn,commandSpeed,commandCurvature,simParams)
    stateOut = stateIn;
    ds = commandSpeed*simParams.updatePeriod;
    stateOut.yaw = stateIn.yaw+commandCurvature*ds;
    stateOut.x = stateIn.x+cos(stateOut.yaw)*ds;
    stateOut.y = stateIn.y+sin(stateOut.yaw)*ds;
end