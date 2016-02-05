#pragma once

namespace support_at {
    class NavState {
    public:
	NavState();
	double m_tranAbsX;
	double m_tranAbsY;
	double m_tranAbsZ;
	double m_tranRelX;
	double m_tranRelY;
	double m_tranRelZ;

	// raw, pitch, roll are not double in ddt::NavState
	double m_roll;
	double m_pitch;
	double m_yaw;

	double m_velX;
	double m_velY;
	double m_velZ;
	double m_speed;
    };
} 

