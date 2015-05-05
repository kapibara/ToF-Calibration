%put depth to ToF camera frame
% d should be corrected depth!
function p3D = depth2world(p, d, calib)

    %compute correction if included in the model
    dc = correct_depth(p, d, calib);

    if(isfield(calib,'ckc'))
        pn = get_dpoint_direction(p(1,:),p(2,:),calib.cK,calib.ckc);
    else
        pn = get_dpoint_direction(p(1,:),p(2,:),calib.cK);
    end
    
    %3D points
    p3D = [pn.*repmat(dc,2,1); dc];
    
end