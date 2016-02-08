#pragma once
#include <support_at/NavState.h>

namespace support_at {
    class VehicleState {
    public:
	VehicleState();
	inline NavState getNavState() const { return m_navState; }
	void setNavState(NavState ns);
    private:
	NavState m_navState;
    };
}
