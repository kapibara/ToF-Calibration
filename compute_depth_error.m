function [e,d,p2d] = compute_depth_error(calib,i)

    global depth_plane_points depth_plane_disparity
   
    calib.cR = eye(3);
    calib.ct = [0;0;0];
    ref_w = render_expected_plane(depth_plane_points{i},calib,calib.cRext{i},calib.ctext{i});
    
%    corrected_depth = correct_depth(depth_plane_points{i}, depth_plane_disparity{i}, calib);
    
    e = depth_plane_disparity{i}-ref_w;
 %   e = corrected_depth - ref_w;
    
    d = depth_plane_disparity{i};
 %d = corrected_depth;
end