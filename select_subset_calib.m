function select_subset_calib(subset)
    global rfiles dfiles cfiles
    
    rfiles{1} = rfiles{1}(subset);
    dfiles = dfiles(subset);
    cfiles = cfiles(subset);
    
    global depth_plane_points depth_plane_mask depth_plane_disparity
    
    depth_plane_points = depth_plane_points(subset);
    depth_plane_mask = depth_plane_mask(subset);
    depth_plane_disparity = depth_plane_disparity(subset);
    
    global conf_grid_p conf_grid_x
    conf_grid_p = conf_grid_p(subset);
    conf_grid_x = conf_grid_x(subset);
    
    global rgb_grid_p rgb_grid_x
    rgb_grid_p{1} = rgb_grid_p{1}(subset);
    rgb_grid_x{1} = rgb_grid_x{1}(subset);
    
    if(length(rgb_grid_x)>1)
        rgb_grid_x{2} = rgb_grid_x{2}(subset);
        rgb_grid_p{2} = rgb_grid_p{2}(subset);
    end
end