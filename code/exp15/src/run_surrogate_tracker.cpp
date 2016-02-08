#include <string>
#include <ades/DataProcessor.h>
#include <ades/PathTracker.h>
#include <support_at/FlatSim.h>
#include <support_at/VehicleState.h>

using namespace ades;

int main(int argv, char** argc) {
    // load path
    DataProcessor dap;
    std::string pathFileName = "data/dummy_path.txt";
    std::vector<vmi::LocVel_T> desiredPath;
    dap.loadPath(pathFileName,desiredPath);

    // set up simulator
    // this has to be a pointer
    support_at::FlatSim sim;

    // set up path tracker
    vmi::PathTracker pt;
    pt.setDesiredPath(desiredPath);

    int controlScale = 5;
    
    double duration = 100.0;
    int simSteps = (int)duration/sim.getUpdatePeriod() + 1;

    int controlCount = 1;

    // initialize vehicle state
    support_at::VehicleState vs;
    
    // initialize desired radius
    double desiredRadius(1.0E06);
    
    // initialize desired curvature
    double desiredCurvature(0.0);

    // initialize desired speed
    double desiredSpeed(0.0);

    // set sim initial commands
    sim.setCommandCurvature(desiredSpeed, desiredCurvature);

    // vehicle state log
    std::vector<support_at::VehicleState> vsLog (simSteps);

    // loop through sim
    for(std::size_t step = 1; step <= (unsigned)simSteps; step++) {
	// update controls
	if(controlCount%controlScale == 0) {
            pt.computeControls(vs, desiredRadius, desiredSpeed);
	    desiredCurvature = 1.0/desiredRadius;
	    sim.setCommandCurvature(desiredSpeed, desiredCurvature);

	    // reset control count
	    controlCount = 1;
	}
	
	// step 
	sim.step();

	// update vehicle state
	vs = sim.getVehicleState();

	// update vehicle state log
	vsLog.push_back(vs);

	// update control count
	controlCount += 1;

	// end of the line
	if(desiredSpeed == 0.0) {
	    std::cout << "End of the line." << std::endl;
	    break;
	}
    }

    // write poses to file
    std::string resFileName("surrogate_tracker_res.txt");
    dap.saveVehicleStateLog(vsLog, resFileName);
}
