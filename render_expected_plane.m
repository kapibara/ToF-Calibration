function ref_w = render_expected_plane(points,calib,Rext,text)
  %Get expected values
  [rN,rd] = extrinsic2plane(Rext,text);
  dN = calib.cR'*rN;
  dd = -dot(calib.ct,rN) + rd;

  xn = get_dpoint_direction_Intel(points(1,:),points(2,:),calib.cK,calib.ckc);
  
  ref_w = dd ./ (dN(1)*xn(1,:)+dN(2)*xn(2,:)+dN(3));
end