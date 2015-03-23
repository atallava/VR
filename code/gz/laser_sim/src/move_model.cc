#include <stdio.h>
#include <iostream>
#include <fstream> 

#include <move_model.h>

namespace gazebo
{
    void FloatingLaser::Load(physics::ModelPtr _parent, sdf::ElementPtr)
	{
	    this->model_ = _parent;
	    
	    std::string file_name = "data/trajs/traj_1.txt";
	    parsePath(file_name);
	    animate();
	}

    void FloatingLaser::parsePath(std::string file_name)
	{
	    std::ifstream file(file_name);
	    double tmp;
	    while (file) {
		// timestamp
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

    void FloatingLaser::animate()
	{
	    gazebo::common::PoseAnimationPtr anim(new gazebo::common::PoseAnimation("traj_anim", duration_, false));
	    gazebo::common::PoseKeyFrame *key;

	    for (size_t i = 0; i < timestamps_.size(); ++i) {
		key = anim->CreateKeyFrame(timestamps_[i]);
		key->SetTranslation(math::Vector3(poses_[i][0],poses_[i][1],0));
		key->SetRotation(math::Quaternion(0,0,poses_[i][2]*0.5));
	    }

	    model_->SetAnimation(anim);
	}

    void FloatingLaser::printInfo()
	{
	    std::cout << "n timestamps: " << timestamps_.size() << "\n";
	    std::cout << "n poses: " << poses_.size() << "\n";
	    std::cout << "traj duration: " << duration_ << "\n";
	}
}
