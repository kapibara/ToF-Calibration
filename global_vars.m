%This file lists all the global variables used
%Run this file to link all variables to the current workspace and access
%the results.
%
% Kinect calibration toolbox by DHC
global dataset_path rfiles rsize dfiles
global rgb_grid_p rgb_grid_x
global depth_corner_p depth_corner_x
global depth_plane_poly depth_plane_mask depth_plane_points depth_plane_disparity
global calib0
global is_validation
global cfiles conf_grid_x conf_grid_p

%max_depth_sample_count: The maximum number of disparity samples used for
%   full calibration. Used to limit memory usage.
global max_depth_sample_count 
max_depth_sample_count = 10000;

if(isempty(calib0))

  calib0.rK = {};               %Color camera intrinsics matrix
  calib0.rkc = {};              %Color camera distortion coefficients
  calib0.rR = {};               %Rotation matrix depth camera to color camera (first is always identity)
  calib0.rt = {};               %Translation vector depth camera to color camera (first is always zero)
  calib0.Rext = [];  %checherboard plane rotation relative to color
  calib0.text = [];  %checherboard plane translation relative to color

  calib0.cK = [];               %ToF intrinsics matrix
  calib0.ckc = [];              %ToF distortion coefficients
  calib0.cRext = [];            %checherboard plane rotation relative to ToF
  calib0.ctext = [];            %checherboard plane translation relative to ToF
  calib0.cR = [];           %1st color camera rotation relative to ToF
  calib0.ct = [];           %1st color camera translation relative to ToF
  
%  calib0.inputs = [];               %X coordinates in regression
%  calib0.res = [];               %Y responce in regression
  calib0.h = 20;             %kernel bandwidth
  calib0.coords = [1 2];             %coordinates from X actually used in regression
  
end

if(isempty(is_validation))
  is_validation = false;
end