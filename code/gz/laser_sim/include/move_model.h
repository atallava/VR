#pragma once
#include <vector>
#include <string>

#include <boost/bind.hpp>
#include <gazebo/gazebo.hh>
#include <gazebo/physics/physics.hh>
#include <gazebo/common/common.hh>


namespace gazebo
{
    class FloatingLaser : public ModelPlugin
    {
    public: 
	void Load(physics::ModelPtr _parent, sdf::ElementPtr);
	void parsePath(std::string file_name);
	void animate();
	void printInfo();
    private: 
	physics::ModelPtr model_;
	std::vector<double> timestamps_;
	double duration_;
	std::vector<std::vector<double> > poses_;
	event::ConnectionPtr updateConnection_;
    };

    GZ_REGISTER_MODEL_PLUGIN(FloatingLaser);
}
