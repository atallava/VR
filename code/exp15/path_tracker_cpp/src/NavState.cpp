#include <support_at/NavState.h>

using namespace support_at;

NavState::NavState() :    m_tranAbsX(0.0),
			  m_tranAbsY(0.0),
			  m_tranAbsZ(0.0),
			  m_tranRelX(0.0),
			  m_tranRelY(0.0),
			  m_tranRelZ(0.0),
			  m_tranAbsYaw(0.0),
			  m_roll(0.0),
			  m_pitch(0.0),
			  m_yaw(0.0),
			  m_velX(0.0),
			  m_velY(0.0),
			  m_velZ(0.0),
			  m_speed(0.0)
{
    
}
