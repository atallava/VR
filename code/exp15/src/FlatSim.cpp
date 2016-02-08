#include <math.h>
#include <support_at/FlatSim.h>
#include <support_at/NavState.h>

using namespace support_at;

FlatSim::FlatSim() : m_updatePeriod(1/10),
		     m_speed(0.0),
		     m_curvature(1/1.0E06)
{
}

void FlatSim::setCommandCurvature(double setSpeed, double setCurvature)
{
    m_speed = setSpeed;
    m_curvature = setCurvature;
}

bool FlatSim::step()
{
    // flat sim only updates x,y,yaw
    NavState ns = m_vs.getNavState();
    double ds = m_speed*m_updatePeriod;
    ns.m_tranAbsYaw += m_curvature*ds;
    ns.m_tranAbsX += ns.m_tranAbsX + cos(ns.m_tranAbsYaw)*ds;
    ns.m_tranAbsY += ns.m_tranAbsY + sin(ns.m_tranAbsYaw)*ds;
    m_vs.setNavState(ns);

    return true;
}
