#include <string>
#include <ades/Test.h>

using namespace ades;

int main() {
    bool res;
    Test t = Test();

    res = t.testBuild();
    printf("Test build: %d.\n",res);

    std::string fileName = "data/dummy_path.txt";
    res = t.testDataProcessor(fileName);
    printf("Test data processor: %d.\n",res);

    // t.testScrap();
}
