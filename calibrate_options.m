% options=calibrate_kinect_options()
% Creates the options struct for calibrate_kinect().
% Set the different use_fixed_* fields to control the degrees of freedom in
% the minimization.
% 
% Kinect calibration toolbox by DHC
function options=calibrate_options()

options.display = 'iter'; %No info
options.correct_depth =0; %use depth correction
options.color_present = 1; %at least one color camera is present
options.max_iter = 5;
