#include <boost/bind.hpp>
#include <gazebo/gazebo.hh>
#include <gazebo/physics/physics.hh>
#include <gazebo/common/common.hh>
#include <stdio.h>

namespace gazebo
{
    class FloatingLaser : public ModelPlugin
    {
    public: void Load(physics::ModelPtr _parent, sdf::ElementPtr)
	{
	    this->model = _parent;
	    
	    gazebo::common::PoseAnimationPtr anim(new gazebo::common::PoseAnimation("test", 10.0, false));
	    gazebo::common::PoseKeyFrame *key;

	    key = anim->CreateKeyFrame(0);
	    key->SetTranslation(math::Vector3(0,0,0));
	    key->SetRotation(math::Quaternion(0,0,0));

	    key = anim->CreateKeyFrame(5);
	    key->SetTranslation(math::Vector3(10,0,0));
	    key->SetRotation(math::Quaternion(0,0,0));

	    key = anim->CreateKeyFrame(10);
	    key->SetTranslation(math::Vector3(20,0,0));
	    key->SetRotation(math::Quaternion(0,0,0));

	    _parent->SetAnimation(anim);
	}

    private: physics::ModelPtr model;
    private: event::ConnectionPtr updateConnection;
    };

    GZ_REGISTER_MODEL_PLUGIN(FloatingLaser);
}
