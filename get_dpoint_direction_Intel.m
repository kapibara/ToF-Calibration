function xn=get_dpoint_direction_Intel(u,v,K,kc)
  xn = [(u-K(1,3)) / K(1,1); 
       (v-K(2,3)) / K(2,2)];
  if(exist('kc','var'))
    xn = undistort(xn,kc);
  end
%   return
%   if(all(calib.dkc==0))
%     xn = [(u-calib.dK(1,3)) / calib.dK(1,1); 
%          (v-calib.dK(2,3)) / calib.dK(2,2)];
%   else
%     idx = sub2ind(size(calib.dlut_x),v+1,u+1);
%     xn = [calib.dlut_x(idx); calib.dlut_y(idx)];
%   end
end