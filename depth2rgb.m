function prgb = depth2rgb(p,d,calib)
    
    p3D = depth2world(p, d, calib);
    
    %3D points in RGB camera space
    p3Drgb = calib.cR * p3D + repmat(calib.ct,1, size(p3D,2)); 
    
    %3d points projection
    prgb = project_points_k(p3Drgb,calib.rK{1},calib.rkc{1});
end