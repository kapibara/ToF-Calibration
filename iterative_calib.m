
options = calibrate_options();

%% iterative calibration

global dataset_path conf_grid_p conf_grid_x depth_plane_points depth_plane_disparity calib0 
global dfiles rgb_grid_p 
global corner_count_x corner_count_y dx

if isempty(dfiles)
    %if needed, select images
    do_select_images_Intel(options);
end

do_process_depth_regions(options);

%save all markups
do_initial_calib_intel(options);

fprintf('Initial Calibration - done\n');
fprintf('Saving the variables \n');
save([dataset_path '/markup.mat'],'conf_grid_p','conf_grid_x',...
'depth_plane_mask','rgb_grid_p','rgb_grid_x',...
'corner_count_x','corner_count_y','dx',...
'rfiles','dfiles','cfiles');


%c = calib0;
errors = [];
iter = 0;

calib = calib0;

if(options.color_present)    
    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
    if(options.depth_in_calib)
        calib.sigma_dplane = std(cost(comp=='P'))*sqrt(sum(comp=='P'))/10;
    else
        calib.sigma_dplane = 1;
    end
    calib.sigma_dcorners = std(cost(comp=='C'))*sqrt(sum(comp=='C'))/10;
    calib.sigma_rgb = std(cost(comp=='R'))*sqrt(sum(comp=='R'))/10;
else
    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options);
    calib.sigma_dplane = std(cost(comp=='P'))*sqrt(sum(comp=='P'))/10;
    calib.sigma_dcorners = std(cost(comp=='C'))*sqrt(sum(comp=='C'))/10;
    calib.sigma_rgb = 1;
end

errors = [errors cost];

errors(comp=='P',:) = errors(comp=='P',:)/calib.sigma_dplane;
errors(comp=='C',:) = errors(comp=='C',:)/calib.sigma_dcorners;
errors(comp=='R',:) = errors(comp=='R',:)/calib.sigma_rgb;

tmp_depth_in_calib = options.depth_in_calib;
options.depth_in_calib = 0;
c = calibrate_intel(options,calib);
options.depth_in_calib = tmp_depth_in_calib;

eval = do_eval(c,options);

[cost,comp] = calibrate_intel_cost(c,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});

errors = [errors cost];
corr = [];
corr_points = 500:10:2000;

if(options.depth_in_calib && options.correct_depth)
    
    calib = fit_depth_correction(c);
    corr = [corr; gaussian_kern_reg(corr_points,calib.inputs,calib.res, calib.h)];
    
    eval = do_eval(calib,options,eval); 

    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
    errors = [errors cost];
    
    
    while(iter < options.max_iter-1)
        
        c = calibrate_intel(options,calib);
        
        eval = do_eval(c,options,eval); 
        
        [cost,comp] = calibrate_intel_cost(c,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
        errors = [errors cost];
        
        calib = fit_depth_correction(c);
        corr = [corr; gaussian_kern_reg(corr_points,calib.inputs,calib.res, calib.h)];
        
        eval = do_eval(calib,options,eval); 
        
        if(options.color_present)
            cost = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
        else
            [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options);
        end

        if(options.eval)
            errors = [errors cost];
        end
        
        iter = iter +1;
    end
    
else
    calib = c;
end
    
    

