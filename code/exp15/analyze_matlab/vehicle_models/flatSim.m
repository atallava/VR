function stateOut = flatSim(stateIn,commandSpeed,commandCurvature,simParams)
    ds = commandSpeed*simParams.updatePeriod;
    stateOut(3) = stateIn(3)+commandCurvature*ds;
    stateOut(1) = stateIn(1)+cos(stateOut(3))*ds;
    stateOut(2) = stateIn(2)+sin(stateOut(3))*ds;
end