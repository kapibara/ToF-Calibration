function [error,depthm,imxy] = compute_full_derror(calib)

global depth_plane_disparity depth_plane_points

error = [];
depthm = [];
imxy = [];

for i=1:length(depth_plane_disparity)
    ei = compute_depth_error(depth_plane_points{i},depth_plane_disparity{i},calib,calib.cRext{i},calib.ctext{i});

    error= [error ei];

    depthm = [depthm depth_plane_disparity{i}];
    imxy = [imxy depth_plane_points{i}];
end

end