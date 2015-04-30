function [error_disp, ref_disp, error_w, ref_w] = get_depth_error_Intel(calib,points,disparity,Rext,text)
  ref_w = get_expected_plane_depth(points,calib,Rext,text);
  
  if(nargout > 2)
    %measured_w = disparity2depth(points(1,:), points(2,:), disparity, calib);
    error_w = measured_w - ref_w;
  end

  %ref_disp = depth2disparity(points(1,:), points(2,:), ref_w, calib);
  ref_disp = ref_w;
  error_disp = disparity - ref_w;
end