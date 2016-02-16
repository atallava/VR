#pragma once
#include <string>
#include <ades/Scrap.h>

namespace ades {
    class Test {
    public:
        bool testBuild();
	bool testDataProcessor(const std::string& fileName);
	bool testScrap();
    };
}
