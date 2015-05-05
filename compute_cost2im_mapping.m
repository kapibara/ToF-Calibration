function cost = compute_cost2im_mapping(options)
    global depth_plane_disparity conf_grid_p rgb_grid_p

    total_count=0;
    total_count = total_count+sum( cellfun(@length, depth_plane_disparity) );
    total_count = total_count+sum (cellfun(@ numel, conf_grid_p) );
    if(options.color_present)
        total_count = total_count + sum (cellfun(@ numel, rgb_grid_p{1}) );
    end
    cost = zeros(total_count,1);
    base = 1;
    for i=find(~cellfun(@(x) isempty(x),depth_plane_disparity))
        cost(base:base+length(depth_plane_disparity{i})-1) = i;
        base = base+length(depth_plane_disparity{i});    
    end
    for i=find(~cellfun(@(x) isempty(x),conf_grid_p))
        cost(base:base+length(conf_grid_p{i}(:))-1) = i;
        base = base+length(conf_grid_p{i}(:));   
    end
    if(options.color_present)
        for i=find(~cellfun(@(x) isempty(x),rgb_grid_p{1}))
            cost(base:base+length(rgb_grid_p{1}{i}(:))-1) = i;
            base = base+length(rgb_grid_p{1}{i}(:));   
        end    
    end
end