function [error,depthm,imxy,imind] = compute_full_derror(calib)

global depth_plane_disparity depth_plane_points

error = [];
depthm = [];
imxy = [];
imind = [];

for i=1:length(depth_plane_disparity)
    ei = compute_depth_error(depth_plane_points{i},depth_plane_disparity{i},calib,calib.cRext{i},calib.ctext{i});

    error= [error ei];
    imind = [imind i*ones(size(ei))];

    depthm = [depthm depth_plane_disparity{i}];
    imxy = [imxy depth_plane_points{i}];
end

end