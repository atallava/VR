#include <iostream>
#include <fstream>
#include <ades/DataProcessor.h>

using namespace ades;

bool DataProcessor::loadPath(const std::string fileName, 
			std::vector<vmi::LocVel_T>& desiredPath)
{
    desiredPath.clear();
    
    std::ifstream ifp(fileName.c_str());
    
    // a line of data
    std::string line;

    // lines containing comment character (anywhere) are ignored
    const char comment('#');

    // the delimiter for the characters
    const char delimiter(',');

    // the location of the delimiter in the line
    std::string::size_type loc(0);
    std::string::size_type prevLoc(0);
    double value(0.0);
    bool parsedAllFields(false);

    // the location, velocity structure
    vmi::LocVel_T locVel;

    // iterate till the end of the stream
    while(!ifp.eof()) {
	// grab a "line" from the file
	std::getline(ifp, line);

	// if the line is not empty
	if(!line.empty()) {
	    // if there are no comments in the line
	    if(std::string::npos == line.find(comment)) {
		// iterate through the number of fields (this is fixed)
		loc = 0;
		prevLoc = loc;
		parsedAllFields = false;
		for(std::size_t idx = 0; idx < 4; idx++) {
		    if(idx != 3) {
			// if the line contains no comment characters
			loc = line.find_first_of(delimiter, prevLoc);

			if(std::string::npos == loc) {
			    break;
			}
		    }
		    else {
			loc = line.length();
		    }
                  
		    // parse out the value
		    value = 
			std::atof(line.substr(prevLoc, loc - prevLoc).c_str());

		    // update prevLoc
		    prevLoc = loc+1;
                    
		    // update the field based on the value of idx
		    switch(idx) {
		    case 0: {
			locVel.loc.x() = value;
			break;
		    }
		    case 1: {
			locVel.loc.y() = value;
			break;
		    }
		    case 2: {
			locVel.speed = value;
			break;
		    }
		    case 3: {
			locVel.yawRate = value;
			parsedAllFields = true;
			break;
		    }
		    default: {
			break;
		    }
		    }
		}

		// if all the fields were parsed, add locVel to m_desiredPath
		if(parsedAllFields) {
		    desiredPath.push_back(locVel);
		}
	    }
	}
    }
                        
    // close the handle
    ifp.close();

    return !desiredPath.empty();
}
