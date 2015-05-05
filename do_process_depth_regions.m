function do_process_depth_regions(options)

    global dataset_path dfiles depth_plane_mask depth_plane_points depth_plane_disparity max_depth_sample_count
    if(isempty(depth_plane_mask))   
        do_select_planes_Intel();
    end
    
    %Get depth samples
    fprintf('Extracting disparity samples...\n');
    [depth_plane_points,depth_plane_disparity] = get_depth_samples(dataset_path,dfiles,depth_plane_mask,options);
    initial_count = sum(cellfun(@(x) size(x,2),depth_plane_points));
    
    [depth_plane_points,depth_plane_disparity] = remove_invalid(depth_plane_points,depth_plane_disparity,options);
    clean_count = sum(cellfun(@(x) size(x,2),depth_plane_points));

    [depth_plane_points,depth_plane_disparity] = reduce_depth_samples(depth_plane_points,depth_plane_disparity,max_depth_sample_count);
    total_count = sum(cellfun(@(x) size(x,2),depth_plane_points));
    fprintf('Initial disparity samples: %d\nClean disparity samples: %d\nUsing %d.\n',initial_count,clean_count,total_count);
end