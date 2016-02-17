#include <string>
#include <ades/DataProcessor.h>
#include <ades/PathTracker.h>
#include <support_at/FlatSim.h>
#include <support_at/VehicleState.h>
#include <support_at/NavState.h>

using namespace ades;

int main(int argv, char** argc) {
    // load path
    DataProcessor dap;
    std::string pathFileName = "data/path_1.txt";
    std::vector<vmi::LocVel_T> desiredPath;
    dap.loadPath(pathFileName,desiredPath);

    // set up simulator
    // this has to be a pointer
    support_at::FlatSim sim;

    // set up path tracker
    vmi::PathTracker pt;
    pt.setDesiredPath(desiredPath);

    int controlScale = 5;
    
    // just a large enough number
    double duration = 200.0;
    int simSteps = (int)duration/sim.getUpdatePeriod() + 1;

    int controlCount = 1;

    // initialize vehicle state
    support_at::VehicleState vs;
    support_at::NavState startNs;
    startNs.m_tranAbsX = desiredPath[0].loc.x();
    startNs.m_tranAbsY = desiredPath[0].loc.y();
    startNs.m_tranAbsYaw = -3.14;
    vs.setNavState(startNs);
    sim.setInitVehicleState(vs);
    
    // initialize desired radius
    double desiredRadius(1.0E06);
    
    // initialize desired curvature
    double desiredCurvature(0.0);

    // initialize desired speed
    double desiredSpeed(0.0);

    // // set sim initial commands
    sim.setCommandCurvature(desiredSpeed, desiredCurvature);

    // vehicle state log
    std::vector<support_at::VehicleState> vsLog;
    vsLog.reserve(simSteps);

    // time log
    std::vector<double> tLog;
    tLog.reserve(simSteps);

    // loop through sim
    for(std::size_t step = 1; step <= (unsigned)simSteps; step++) {
    	// update controls
    	if(controlCount%controlScale == 0) {
	    pt.computeControls(vs, desiredRadius, desiredSpeed);

	    // print controls
	    // std::cout << "Commanded radius: " << desiredRadius 
	    // 	      << " speed: " << desiredSpeed
	    // 	      << std::endl;

	    // end of the line
	    if(desiredSpeed == 0.0) {
		std::cout << "End of tracking, sim step: " << step << std::endl;
		break;
	    }

    	    desiredCurvature = 1.0/desiredRadius;
    	    sim.setCommandCurvature(desiredSpeed, desiredCurvature);

    	    // reset control count
    	    controlCount = 0;
    	}
	
    	// step 
    	sim.step();

    	// update vehicle state
    	vs = sim.getVehicleState();

	// print nav state
	// support_at::NavState ns = vs.getNavState();
	// std::cout << "Vehicle x: " << ns.m_tranAbsX
	// 	  << " y: " << ns.m_tranAbsY
	// 	  << " yaw: " << ns.m_tranAbsYaw
	// 	  << std::endl;

    	// update vehicle state log
    	vsLog.push_back(vs);

	tLog.push_back((step-1)*sim.getUpdatePeriod());

    	// update control count
    	controlCount += 1;
    }

    // print nav state
    // support_at::NavState ns = vs.getNavState();
    // std::cout << "Vehicle x: " << ns.m_tranAbsX
    // 	  << " y: " << ns.m_tranAbsY
    // 	  << " yaw: " << ns.m_tranAbsYaw
    // 	  << std::endl;

    // write poses to file
    std::string resFileName("data/surrogate_tracker_res.txt");
    dap.saveVehicleStateLog(vsLog, tLog, resFileName);

    return 1;
}
