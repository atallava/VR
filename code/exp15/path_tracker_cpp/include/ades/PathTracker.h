//! Mode:c++

//===============================================================================
/*! 
  \file PathTracker.h

  \author Venkat Rajagopalan
  \date   02/18/2014
  
  \attention
  Copyright (C) 2011 \n
  National Robotics Engineering Center (NREC) \n
  Robotics Institute
  Carnegie Mellon University
  All Rights Reserved \n
*/
//===============================================================================
#ifndef Path_Tracker_h
#define Path_Tracker_h

//-------------------------------------------------------------------------------
// INCLUDES
//-------------------------------------------------------------------------------
#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/log/sources/severity_logger.hpp>

#include <support_at/Point2D.h>

/* NREC code 
#include <Simple3DSim/Simple3DSim.h>
*/
#include <support_at/VehicleState.h>

#include <ades/PathLocalizer.h>


//-------------------------------------------------------------------------------
namespace vmi
{

 //-----------------------------------------------------------------------------
  struct LocVel_T
  {
    // the default constructor
    LocVel_T():
      loc(support_at::Point2D_d(0.0, 0.0)),
      speed(0.0),
      yawRate(0.0)
    {
    };

    // the 2D Location
    support_at::Point2D_d loc;

    // the longitudinal speed (m/sec)
    double speed;

    // yaw rate (degrees/sec)
    double yawRate;

  };

  //-----------------------------------------------------------------------------
  class PathTracker : public boost::noncopyable 
  {
  public:

    //---------------------------------------------------------------------------
    // the default constructor
    PathTracker();

    //---------------------------------------------------------------------------
    // destructor
    ~PathTracker();

    //---------------------------------------------------------------------------
    // load the waypoint path
    //! param [in] the fully qualified file name
    bool loadPath(const std::string fileName);

    //---------------------------------------------------------------------------
    // update the path
    bool setDesiredPath(const std::vector<LocVel_T>& desiredPath);

    //---------------------------------------------------------------------------
    bool getClosestPoint(const support_at::VehicleState& vs, 
                         support_at::Point2D_d& closestPt);

    //---------------------------------------------------------------------------
    // param [in] currentState - the current state of the vehicle
    // param [out] desiredRadius - the desired radius to get to the path at 
    //                             some look ahead distance
    // param [out] desiredSpeed  - the desired speed to execute the  
    // returns true on success and false otherwise
    bool computeControls(const support_at::VehicleState& vs,
                         double& desiredRadius,
                         double& desiredSpeed);

    //---------------------------------------------------------------------------
    void purgeOldSegments();

    inline const double getLADist() const { return m_lADist; }
    void setLADist(double laDist);

  private:
    
    // the "localizer" object for this class
    PathLocalizer m_localizer;

    // the path 
    std::vector<LocVel_T> m_desiredPath;

    // the computed desired steering radius
    double m_desiredRadius;

    // the computed desired longitudinal velocity
    double m_desiredSpeed;

    // for ades, tunable lookahead distance
    double m_lADist;

    // the logging object for this class
    static boost::log::sources::severity_logger<> m_logger;

    // the maximum deceleration of the platform
    static const double ms_maxDecel;

    // the maximum acceleration of the platform
    static const double ms_maxAccel;

    // for the Husky, it will be sufficient to setup 
    // a fixed look ahead distance of xx.xxx meters
    // MPC version
    /* static const double ms_fixedLADist; */
    
    // maximum distance beyond which the algorithm will
    // refuse to do pure-pursuit
    static const double ms_maxDistanceThreshold;

    // the "progress" threshold to be considered done following
    static const double ms_progressForDone;

  };



} // end namespace scope

#endif // Path_Tracker_h
