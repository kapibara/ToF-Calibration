function [e,d] = compute_depth_error(points,depth,calib,R,t)

    ref_w = render_expected_plane(points,calib,R,t);
    
    corrected_depth = correct_depth(points,depth,calib);
    
    e = corrected_depth-ref_w;

    d = corrected_depth;
end