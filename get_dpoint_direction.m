function xn=get_dpoint_direction(u,v,K,kc)
  xn = [(u-K(1,3)) / K(1,1); 
       (v-K(2,3)) / K(2,2)];
  if(exist('kc','var'))
    xn = undistort(xn,kc);
  end
end