#include <support_at/VehicleState.h>
#include <support_at/NavState.h>

using namespace support_at;

VehicleState::VehicleState()
{
}

void VehicleState::setNavState(NavState ns)
{
    m_navState = ns;
}
