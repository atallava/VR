#include <stdio.h>
#include <iostream>
#include <fstream> 
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
    public: void Load(physics::ModelPtr _parent, sdf::ElementPtr)
	{
	    this->model_ = _parent;
	    
	    std::string file_name = "data/trajs/traj_1.txt";
	    parsePath(file_name);
	    animate();
	}

    public: void parsePath(std::string file_name)
	{
	    std::ifstream file(file_name);
	    double tmp;
	    while (file) {
		// timestampp
		file >> tmp;
		if(!file)
		    break;
		timestamps_.push_back(tmp);

		// pose
		std::vector<double> pose;
		for (size_t i = 0; i < 3; ++i) {
		    file >> tmp;
		    pose.push_back(tmp);
		}
		poses_.push_back(pose);
	    }		
	    duration_ = timestamps_.back();
	}

    public: void animate()
	{
	    gazebo::common::PoseAnimationPtr anim(new gazebo::common::PoseAnimation("traj_anim", duration_, false));
	    gazebo::common::PoseKeyFrame *key;

	    for (size_t i = 0; i < timestamps_.size(); ++i) {
		key = anim->CreateKeyFrame(timestamps_[i]);
		key->SetTranslation(math::Vector3(poses_[i][0],poses_[i][1],0));
		key->SetRotation(math::Quaternion(0,0,0));
	    }

	    model_->SetAnimation(anim);
	}

    public: void printInfo()
	{
	    std::cout << "n timestamps: " << timestamps_.size() << "\n";
	    std::cout << "n poses: " << poses_.size() << "\n";
	    std::cout << "traj duration: " << duration_ << "\n";
	}

    private: physics::ModelPtr model_;
    private: std::vector<double> timestamps_;
    private: double duration_;
    private: std::vector<std::vector<double> > poses_;
    private: event::ConnectionPtr updateConnection_;
    };

    GZ_REGISTER_MODEL_PLUGIN(FloatingLaser);
}
