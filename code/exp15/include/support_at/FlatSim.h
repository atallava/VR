#pragma once
#include <support_at/VehicleState.h>

namespace support_at {
    class FlatSim {
    public:
	FlatSim();
	void setCommandCurvature(double setSpeed, double setCurvature);
	bool step();
	inline double getUpdatePeriod() const { return m_updatePeriod; }
	inline double getUpdateRate() const { return 1/m_updatePeriod; }
	inline VehicleState getVehicleState() const { return m_vs; }
    private:
	VehicleState m_vs;
	double m_updatePeriod;
	double m_speed;
	double m_curvature;
    };
}
