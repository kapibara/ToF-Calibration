function cost = calibrate_intel_cost_depth_corners(calib,conf_grid_x,conf_grid_p)
    
    total_count = sum (cellfun(@ numel, conf_grid_p) );
    cost=zeros(total_count,1);
    
    base = 1;
    for i=find(~cellfun(@(x) isempty(x),conf_grid_p))
    
        %corner-based error
        X = conf_grid_x{i};
        p = project_points_k(X,calib.cK,calib.ckc,calib.cRext{i},calib.ctext{i});
        corner_error = conf_grid_p{i}-p;
        cost(base:base+numel(corner_error)-1) = corner_error(:)';
        base = base+numel(corner_error);
    
    end

    if(isfield(calib,'sigma_dcorners'))
        cost = cost/calib.sigma_dcorners;
    end
end