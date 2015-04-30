function save_globals(fn)

global dataset_path dfiles depth_plane_mask
global calib0
global max_depth_sample_count
global is_validation
global rgb_grid_p rgb_grid_x rfiles
global depth_plane_points depth_plane_disparity
global cfiles conf_grid_p conf_grid_x

save([dataset_path fn],'dataset_path','dfiles',...
        'rfiles','depth_plane_mask',...
        'calib0','max_depth_sample_count',...
        'is_validation','rgb_grid_p','rgb_grid_x',...
        'depth_plane_points','depth_plane_disparity',...
        'cfiles','conf_grid_p','conf_grid_x');

end