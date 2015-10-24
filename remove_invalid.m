function [depth_plane_points,depth_plane_disparity] = remove_invalid(depth_plane_points,depth_plane_disparity,options)
    is_inv_disp = cellfun(@(x) x == 0,depth_plane_disparity ,'UniformOutput',false);
    depth_plane_points = cellfun(@(x,y) x(:,~y),depth_plane_points,is_inv_disp,'UniformOutput',false);
    depth_plane_disparity = cellfun(@(x,y) x(~y),depth_plane_disparity,is_inv_disp,'UniformOutput',false);
end
