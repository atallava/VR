#pragma once
#include <string>
#include <vector>
#include <ades/PathTracker.h>

namespace ades {
    class DataProcessor {
    public:
	bool loadPath(const std::string fileName, 
		      std::vector<vmi::LocVel_T>& desiredPath);
    };
} // end of namespace
