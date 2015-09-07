
options = calibrate_options();
%% iterative calibration
global dataset_path conf_grid_p conf_grid_x depth_plane_points depth_plane_disparity calib0 
global dfiles rgb_grid_p 

if isempty(dfiles)
    %if needed, select images
    do_select_images_Intel(options);
end

do_process_depth_regions(options);

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


%options.depth_in_calib = 0;
c = calibrate_intel(options,calib);
%options.depth_in_calib = 1;

[result,~] = stairs_type_eval_intel(c,'/home/kuznetso/tmp/CalibData/planes_intel/',options,1);
totalfb = result.distfb(:,1);
total12 = result.dist12(:,1);
total21 = result.dist21(:,1);

[result,~] = angle_type_eval_intel(c,'/home/kuznetso/tmp/CalibData/box_intel/',options,1);
totala = result.angle(:,1);

[cost,comp] = calibrate_intel_cost(c,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});

errors = [errors cost];
corr = [];

if(options.correct_depth)
    
    calib = fit_depth_correction(c);
    corr = [corr; gaussian_kern_reg(150:10:900,calib.inputs,calib.res, calib.h)];
    
    [result,~] = stairs_type_eval_intel(calib,'/home/kuznetso/tmp/CalibData/planes_intel/',options,1);
    totalfb = [totalfb result.distfb(:,1)];
    total12 = [total12 result.dist12(:,1)];
    total21 = [total21 result.dist21(:,1)];    
    [result,~] = angle_type_eval_intel(calib,'/home/kuznetso/tmp/CalibData/box_intel/',options,1);
    totala = [totala result.angle(:,1)];
    
    [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
    errors = [errors cost];
    while(iter < options.max_iter-1)
        
        c = calibrate_intel(options,calib);
        
        [result,~] = stairs_type_eval_intel(c,'/home/kuznetso/tmp/CalibData/planes_intel/',options,1);
        totalfb = [totalfb result.distfb(:,1)];
        total12 = [total12 result.dist12(:,1)];
        total21 = [total21 result.dist21(:,1)];    
        
        [result,~] = angle_type_eval_intel(c,'/home/kuznetso/tmp/CalibData/box_intel/',options,1);
        totala = [totala result.angle(:,1)];
        
        [cost,comp] = calibrate_intel_cost(c,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
        errors = [errors cost];
        
        calib = fit_depth_correction(c);
        
        corr = [corr; gaussian_kern_reg(150:10:900,calib.inputs,calib.res, calib.h)];
        
        [result,~] = stairs_type_eval_intel(calib,'/home/kuznetso/tmp/CalibData/planes_intel/',options,1);
        totalfb = [totalfb result.distfb(:,1)];
        total12 = [total12 result.dist12(:,1)];
        total21 = [total21 result.dist21(:,1)];            
 
        [result,~] = angle_type_eval_intel(calib,'/home/kuznetso/tmp/CalibData/box_intel/',options,1);
        totala = [totala result.angle(:,1)];
        
        if(options.color_present)
            cost = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1});
        else
            [cost,comp] = calibrate_intel_cost(calib,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options);
        end

        errors = [errors cost];

        iter = iter +1;
    end
    
else
    calib = c;
end
    
    

