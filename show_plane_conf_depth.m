function show_plane_conf_depth(calib,i)
    global  depth_plane_points depth_plane_disparity
    
    grid = grid2world(i,calib);
    
    p3D = depth2world(depth_plane_points{i}, depth_plane_disparity{i}, calib);
    
    plot3(grid(1,:),grid(2,:),grid(3,:),'or');
    hold on
    plot3(p3D(1,:),p3D(2,:),p3D(3,:),'+b');
    axis equal
end