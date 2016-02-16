#include <string>
#include <ades/Test.h>
#include <ades/PathTracker.h>
#include <ades/DataProcessor.h>

using namespace ades;

bool Test::testBuild()
{
    return true;
}

bool Test::testDataProcessor(const std::string& fileName)
{
    DataProcessor dap;
    std::vector<vmi::LocVel_T> path;
    bool res = dap.loadPath(fileName,path);

    return res;
}

bool Test::testScrap()
{
    Scrap obj;
    obj.x() = 1.0;
    obj.y() = 2.0;
    printf("obj.x: %.2f\n",obj.x());
    printf("obj.y: %.2f\n",obj.y());
    obj.m_x = 3.0;
    obj.m_y = 4.0;
    printf("obj.x: %.2f\n",obj.x());
    printf("obj.y: %.2f\n",obj.y());

    return true;
}


