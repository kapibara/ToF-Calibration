function cost = calibrate_intel_cost_raw(raw_params,params0,depth_points,depth_depth,conf_grid_p,conf_grid_x,rgb_grid_p)
    calib = calibrate_intel_r2s(raw_params,params0);
    
    if (exist('rgb_grid_p','var'))
        cost = calibrate_intel_cost(calib,depth_points,depth_depth,conf_grid_p,conf_grid_x,rgb_grid_p);
    else
        cost = calibrate_intel_cost(calib,depth_points,depth_depth,conf_grid_p,conf_grid_x);
    end
end
