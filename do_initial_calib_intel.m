%% initialize calibration

function do_initial_calib_intel(options)

    global calib0

    %do corner-based calibration
    do_initial_conf_calib();
    
    if(options.color_present)
        do_initial_rgb_calib();
        %relative transformation initialization
        [calib0.cR,calib0.ct]=estimate_relative(calib0);
    end
    
    if(options.correct_depth)
        %set the coordinates to use in regression
        calib0.coords = [1 2];
    end
end