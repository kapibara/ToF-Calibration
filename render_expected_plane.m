function ref_w = render_expected_plane(points,calib,Rext,text)
  %Get expected values
  [rN,rd] = extrinsic2plane(Rext,text);

  xn = get_dpoint_direction(points(1,:),points(2,:),calib.cK,calib.ckc);
  
  ref_w = rd ./ (rN(1)*xn(1,:)+rN(2)*xn(2,:)+rN(3));
end