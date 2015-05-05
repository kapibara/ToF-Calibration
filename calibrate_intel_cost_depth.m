% cost=calibrate_intel_cost_depth(params,options,depth_plane_points,depth_plane_disparity)
% Cost for depth images, used by calibrate_intel_cost;
% Uses both depth and corner-based cost on confidence map
%
% Kinect calibration toolbox by DHC
function [cost, comp]=calibrate_intel_cost_depth(calib,depth_points,depth_depth,conf_grid_x,conf_grid_p,options)

    cost_pl = calibrate_intel_cost_depth_plane(calib,depth_points,depth_depth);
    cost_corner = calibrate_intel_cost_depth_corners(calib,conf_grid_x,conf_grid_p);  
    
    cost = [(options.depth_in_calib~=0)*cost_pl; cost_corner];
    
    comp = zeros(length(cost),1);
    comp(1:length(cost_pl)) = repmat('P',length(cost_pl),1);
    comp(length(cost_pl)+1:end) = repmat('C',length(cost_corner),1);

end

%pause
