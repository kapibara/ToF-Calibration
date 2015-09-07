% cost=calibrate_intel_cost_depth(params,options,depth_plane_points,depth_plane_disparity)
% Cost for depth images, used by calibrate_intel_cost;
% Uses both depth and corner-based cost on confidence map
%
% Kinect calibration toolbox by DHC
function [cost, comp ] =calibrate_intel_cost(calib,depth_points,depth_depth,conf_grid_x,conf_grid_p,options,rgb_grid_p)

    [cost_depth, comp] = calibrate_intel_cost_depth(calib,depth_points,depth_depth,conf_grid_x,conf_grid_p,options);
    
    if (exist('rgb_grid_p','var'))
        cost_rgb = calibrate_intel_cost_color(calib, conf_grid_x, rgb_grid_p);
        
        comp = [comp; repmat('R',length(cost_rgb),1)];
    
  %      cost = [cost_depth; cost_rgb/length(cost_rgb)];
        cost = [cost_depth; cost_rgb];
    else
        cost = cost_depth;
    end

end

%pause
