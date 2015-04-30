function corrected_depth = correct_depth(points, depth, calib)

    if(~isfield(calib,'inputs'))
        %warning('calib does not have any inputs filed; no depth correction');
        corrected_depth = depth;
        return;
    end

    inputs = [depth; points];

    corrected_depth = depth - gaussian_kern_reg(inputs(calib.coords,:),calib.inputs,calib.res, calib.h);
        
end