function cost = calibrate_intel_cost_depth_plane(calib,depth_plane_points,depth_plane_disparity)
    %plane-based cost
    total_count = sum( cellfun(@length, depth_plane_disparity) );
    cost=zeros(total_count,1);
    
    base = 1;
    
    for i=intersect(find(~cellfun(@(x) isempty(x),depth_plane_points)),find(~cellfun(@(x) isempty(x),calib.cRext)))
        
        disp_error = compute_depth_error(depth_plane_points{i},depth_plane_disparity{i},calib,calib.cRext{i},calib.ctext{i});

        cost(base:base+length(disp_error)-1) = disp_error';
        base = base+length(disp_error);    
    end
    
    if(isfield(calib,'sigma_dplane'))
        cost = cost/calib.sigma_dplane;
    end
end