function cost = calibrate_intel_cost_color(calib, conf_grid_x, rgb_grid_p)
    total_count = sum (cellfun(@ numel, rgb_grid_p) );
    cost=zeros(total_count,1);
    
    base = 1;

    for i=intersect(find(~cellfun(@(x) isempty(x),rgb_grid_p)),find(~cellfun(@(x) isempty(x),conf_grid_x)))
        X = conf_grid_x{i};
        
        R = calib.cR*calib.cRext{i};
        t = calib.cR*calib.ctext{i} + calib.ct;
        
        p = project_points_k(X,calib.rK{1},calib.rkc{1},R,t);
        
 
        corner_error = rgb_grid_p{i}-p;
        cost(base:base+numel(corner_error)-1) = corner_error(:)';
        base = base+numel(corner_error);
    end
    
    if(isfield(calib,'sigma_rgb'))
        cost = cost/calib.sigma_rgb;
    end
end