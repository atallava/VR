#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <pcl/io/pcd_io.h>
#include <pcl/visualization/cloud_viewer.h>
#include <pcl/point_types.h>
#include <pcl/registration/icp.h>
#include <pcl/console/parse.h>
#include <boost/make_shared.hpp>

void PrintUsage(const char* prog_name)
{
  std::cout << "\nUsage: " << prog_name << " [options] \n\n"
	    << "Options:\n"
	    << "-h this help\n"
	    << "-s <source> <target> match a single source pcd to target and display transformation -v visualize after match \n"
	    << "-f <directory> <num_scans> <output_file> match all scans in directory to map in directory and write transform to specified file\n"
	    << "\n\n";
}

void VizMatches(const pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_target, const pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_src, const pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_match)
{
  pcl::visualization::PCLVisualizer viewer("viz");
  viewer.initCameraParameters();
  pcl::visualization::PointCloudColorHandlerCustom<pcl::PointXYZ> cloud_target_color_handler (cloud_target, 255, 255, 255);

  int v1(0);
  viewer.createViewPort(0.0, 0.0, 0.5, 1.0, v1);
  viewer.addText("Source", 10, 10, "v1 text", v1);
  viewer.addPointCloud<pcl::PointXYZ> (cloud_target, cloud_target_color_handler, "cloud_target_v1", v1);
  pcl::visualization::PointCloudColorHandlerCustom<pcl::PointXYZ> cloud_src_color_handler (cloud_src, 255, 0, 0);
  viewer.addPointCloud(cloud_src, cloud_src_color_handler, "cloud_src", v1);
  
  int v2(0);
  viewer.createViewPort(0.5, 0.0, 1.0, 1.0, v2);
  viewer.addText("Match", 10, 10, "v2 text", v2);
  viewer.addPointCloud<pcl::PointXYZ> (cloud_target, cloud_target_color_handler, "cloud_target_v2", v2);
  pcl::visualization::PointCloudColorHandlerCustom<pcl::PointXYZ> cloud_match_color_handler (cloud_match, 0.0, 255.0, 0.0);
  viewer.addPointCloud(cloud_match, cloud_match_color_handler, "cloud_match", v2);

  viewer.addCoordinateSystem(1.0);
  viewer.setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 2, "cloud_src");
  viewer.setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 2, "cloud_target_v1");
  viewer.setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 2, "cloud_target_v2");
  viewer.setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 2, "cloud_match");
  
  while (!viewer.wasStopped()) {
    viewer.spinOnce();
  }
}

int main(int argc, char** argv)
{
  if(pcl::console::find_argument(argc, argv, "-h") >= 0)
    {
      PrintUsage(argv[0]);
      return 0;
    }
  pcl::IterativeClosestPoint<pcl::PointXYZ, pcl::PointXYZ> icp;
  if(pcl::console::find_argument(argc, argv, "-s") >= 0)
    {
      std::string src_name = argv[2];
      std::string target_name = argv[3];
      pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_map (new pcl::PointCloud<pcl::PointXYZ>);
      pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_scan (new pcl::PointCloud<pcl::PointXYZ>);
      pcl::io::loadPCDFile<pcl::PointXYZ> (src_name, *cloud_scan);
      pcl::io::loadPCDFile<pcl::PointXYZ> (target_name, *cloud_map);

      icp.setInputTarget(cloud_map);
      pcl::PointCloud<pcl::PointXYZ> cloud_match;
      icp.setInputCloud(cloud_scan);
      icp.align(cloud_match);

      std::cout << "has converged: " << icp.hasConverged() << " score: " << icp.getFitnessScore() << std::endl;
      if (pcl::console::find_argument(argc, argv, "-v") >= 0)
	{
	  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_match_ptr = boost::make_shared<pcl::PointCloud<pcl::PointXYZ> >(cloud_match);
	  VizMatches(cloud_map, cloud_scan, cloud_match_ptr);
	}
    }
  else if(pcl::console::find_argument(argc, argv, "-f") >= 0)
    {
      std::string dir = argv[2];
      std::string map_name = dir + "/map.pcd";
      pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_map (new pcl::PointCloud<pcl::PointXYZ>);
      pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_scan (new pcl::PointCloud<pcl::PointXYZ>);
      pcl::PointCloud<pcl::PointXYZ> cloud_match;
      pcl::io::loadPCDFile<pcl::PointXYZ> (map_name, *cloud_map);
      icp.setInputTarget(cloud_map);      

      std::string out_name = dir + "/poses_after_icp.txt";
      std::ofstream fout(argv[4]);
      fout << "scan " << "converged " << "score " << "pose" << std::endl;
      Eigen::IOFormat out_format(4, 0, ",", ",", "", "", "[", "]");
  
      int num_files = atoi(argv[3]);
      char temp[100];
      for (int i = 0; i < num_files; i++) {
	std::cout << "scan " << i+1 << std::endl;
	// Load data
	std::string scan_name = dir + "/cleaned_scan_" + std::to_string(i+1) + ".pcd";
	//std::string scan_name = dir + "/scan_" + std::to_string(i+1) + ".pcd";
	pcl::io::loadPCDFile<pcl::PointXYZ> (scan_name, *cloud_scan);
	
	// Match
	icp.setInputCloud(cloud_scan);
	icp.align(cloud_match);
	std::cout << "has converged: " << icp.hasConverged() << " score: " << std::endl;
	Eigen::Matrix4f matchTransform = icp.getFinalTransformation();
	std::cout << matchTransform << std::endl;
	fout << i+1 << " " << icp.hasConverged() << " " << icp.getFitnessScore() << " " << matchTransform.transpose().format(out_format) << std::endl;
      }
      
      fout.close();
    }
  else
    {
      PrintUsage(argv[0]);
    }

  return (0);
}
