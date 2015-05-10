% options=calibrate_kinect_options()
% Creates the options struct for calibrate_kinect().
% Set the different use_fixed_* fields to control the degrees of freedom in
% the minimization.
% 
% Kinect calibration toolbox by DHC
function options=calibrate_options()

options.display = 'iter'; %No info
options.correct_depth = 1; %use depth correction
options.depth_in_calib = 1;%use depth measurements in calibration
options.color_present = 1; %at least one color camera is present
options.max_iter = 5;
%options.read_image = @(im_path) <custom function that loads an image>
options.invalid_depth = 0; %the value used to denote invalid depth values
