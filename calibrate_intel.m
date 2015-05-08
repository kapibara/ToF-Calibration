%[params,params_error]=calibrate_kinect(options,rgb_grid_p,rgb_grid_x,depth_plane_points,depth_plane_disparity,params0)
% Performas a non-linear minimization of the calibration parameters using
% levenberg-marquardt algorithm.
%
% options struct created with calibrate_kinect_options()
% rgb_grid_p {K}{N}[2xP] cell array of color corner locations in image coordinates
% rgb_grid_x {K}{N}[2xP] cell array of color corner locations in world coordinates
% depth_plane_points {N}[2xP] cell array of image coordinates of points in the 
%     depth image that belong to the calibration plane.
% depth_plane_disparity {N}[1xP] cell array of disparity values of points in the 
%     depth image that belong to the calibration plane.
% params0 struct with the following fields:
% 	rK {K}[fx 0 u0; 0 fy v0; 0 0 1] intrinsics for rgb camera 
% 	rkc {K}[1x5] distortion coefficients for rgb camera
% 	rR {K}[3x3] rotation matrix from camera k to camera 1 (r1X = rR{k} * rkX + rt{k})
% 	rt {K}[3x1] translation vector from camera k to camera 1 (r1X = rR{k} *	rkX + rt{k})
% 	dK [fx 0 u0; 0 fy v0; 0 0 1] intrinsics for depth camera 
% 	dkc [1x5] distortion coefficients for depth camera
% 	dc [1x2] coefficients for disparity-depth function
% 	dR [3x3] relative rotation matrix (r1X = dR * dX + dt)
% 	dt [3x1] relative translation vector (r1X = dR * dX + dt)
% 	Rext {N}[3x3] cell array of rotation matrices grid to camera 1
%             one for each image (r1X = Rext * gridX + text)
% 	text {N}[3x1] cell array of translation vectors grid to camera 1
%             one for each image (r1X = Rext * gridX + text)
%
% params calibrated parameters, same structure as params0
% params_error tolerances of the calibration parameters
%
% Kinect calibration toolbox by DHC
function calib=calibrate_intel(options,calib0)

    global conf_grid_x conf_grid_p depth_plane_points depth_plane_disparity rgb_grid_p

    %Encode params
    raw0 = calibrate_intel_s2r(calib0);
    %raw0 = calibrate_s2r_pose(calib0);
    %raw0 = calibrate_s2r_int(calib0);
    
    %Minimize
    minimization_options=optimset('LargeScale','off',...
        'Algorithm','levenberg-marquardt',...
        'Display',options.display, ...
        'OutputFcn', @my_output_fcn, ...
        'TolFun',1e-4,...
        'TolX',1e-8,...
        'MaxFunEvals',20000,...
        'MaxIter',1000);

     % jacob_pattern = calibrate_kinect_jacobian_pattern(options,params0,rgb_grid_p,depth_plane_points);
    % minimization_options=optimset('LargeScale','on','JacobPattern',jacob_pattern,'Display',options.display, 'TolFun',1e-4,'TolX',1e-8,'MaxFunEvals',20000,'MaxIter',1000);

    if(~strcmp(options.display,'off'))
        fprintf('Minimizing cost function over %d parameters...',length(raw0));
    end
    tStart = tic();
  
    if(options.color_present)
        [raw_final,~,~,~,~,~,calib_jacobian] = lsqnonlin(@(x) calibrate_intel_cost_raw(x,calib0,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options,rgb_grid_p{1}),raw0,[],[],minimization_options);
    else
        [raw_final,~,~,~,~,~,calib_jacobian] = lsqnonlin(@(x) calibrate_intel_cost_raw(x,calib0,depth_plane_points,depth_plane_disparity,conf_grid_x,conf_grid_p,options),raw0,[],[],minimization_options);      
    end
    
    tElapsed = toc(tStart);
    if(~strcmp(options.display,'off'))
        display(['Done ' num2str(tElapsed) 's']);
    end

    %Decode params
    calib = calibrate_intel_r2s(raw_final,calib0);
    %calib = calibrate_r2s_pose(raw_final,calib0);
    %calib = calibrate_r2s_int(raw_final,calib0);
end

function res=my_output_fcn(cost,optimValues,state)
  fprintf('.');
  res = false;
end