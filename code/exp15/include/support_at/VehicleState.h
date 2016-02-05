#pragma once
#include "NavState.h"

namespace support_at {
    class VehicleState {
    public:
	VehicleState();
	NavState getNavState();
	void setNavState(NavState ns);
    private:
	m_navState;
    };
}
