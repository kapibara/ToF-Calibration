
options = calibrate_options();
%% iterative calibration
global dataset_path conf_grid_p conf_grid_x depth_plane_points depth_plane_disparity calib0 depth_plane_mask
global dfiles rgb_grid_p rgb_grid_x

if isempty(dfiles)
    %if needed, select images
    do_select_images_Intel(options);
end

do_process_depth_regions();

%save all markups

do_initial_calib_intel(options);

fprintf('Initial Calibration - done\n');
fprintf('Saving the variables \n');
save([dataset_path '/markup.mat'],'conf_grid_p','conf_grid_x','depth_plane_mask','rgb_grid_p','rgb_grid_x');


%c = calib0;
errors = [];
iter = 0;


calib = calib0;

if(options.color_present)
    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,rgb_grid_p{1});
    calib.sigma_dplane = std(cost(comp=='P'));
    calib.sigma_dcorners = std(cost(comp=='C'));
    calib.sigma_rgb = std(cost(comp=='R'));
else
    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p);
    calib.sigma_dplane = std(cost(comp=='P'));
    calib.sigma_dcorners = std(cost(comp=='C'));
    
end

errors = [errors cost];

calib.sigma_dplane = 1;
errors(comp=='P',:) = errors(comp=='P',:)/calib.sigma_dplane;
errors(comp=='C',:) = errors(comp=='C',:)/calib.sigma_dcorners;
errors(comp=='R',:) = errors(comp=='R',:)/calib.sigma_rgb;

c = calibrate_intel(options,calib);

if(options.correct_depth)
    
    calib = fit_depth_correction(c);

    while(iter < options.max_iter-1)
        
        c = calibrate_intel(options,calib);
        
        calib = fit_depth_correction(c);

        if(options.color_present)
            cost = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,rgb_grid_p{1});
        else
            [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p);
        end

        errors = [errors cost];

        iter = iter +1;
    end
    
else
    calib = c;
end
    
    

