#pragma once
#include <string>
#include <vector>
#include <ades/PathTracker.h>
#include <support_at/VehicleState.h>

namespace ades {
    class DataProcessor {
    public:
	bool loadPath(const std::string fileName, 
		      std::vector<vmi::LocVel_T>& desiredPath);
	bool saveVehicleStateLog(std::vector<support_at::VehicleState> vsLog,
				 std::string fileName);
    };
} // end of namespace
