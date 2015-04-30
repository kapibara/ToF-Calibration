function cost = calibrate_intel_cost_depth_plane(calib,depth_plane_points,depth_plane_disparity)
    %plane-based cost
    total_count = sum( cellfun(@length, depth_plane_disparity) );
    cost=zeros(total_count,1);
    
    base = 1;
    
    for i=find(~cellfun(@(x) isempty(x),depth_plane_points))
%    for i=1:length(index)
        
    %depth rendering error
        ref_w = render_expected_plane(depth_plane_points{i},calib,calib.cRext{i},calib.ctext{i});  
        
        corr_depth = correct_depth(depth_plane_points{i}, depth_plane_disparity{i}, calib);
        
        if (sum(isnan(corr_depth))>0)
            warning('NaN problem')
        end
        %corr_depth = depth_plane_disparity{i};
        
        disp_error = corr_depth - ref_w; %because  ref_w is computed in m, and disparity is in mm
  
        cost(base:base+length(disp_error)-1) = disp_error';
        base = base+length(disp_error);    
    end
    
    if(isfield(calib,'sigma_dplane'))
        cost = cost/calib.sigma_dplane;
    end
end