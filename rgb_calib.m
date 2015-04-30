%[K,R,t,kc,error_var]=rgb_calib(K0,kc0,R0,t0,rgb_grid_p,rgb_grid_x,use_fixed_intrinsic)
% Calibration of a color camera through non-linear minimization.
%
% K0 [3x3] initial intrinsics matrix
% kc0 [1x5] initial distortion coefficients
% R0 {N}[3x3] cell array of initial world to camera rotations
% t0 {N}[3x1] cell array of initial world to camera translations
% rgb_grid_p {N}[2xP] cell array of corner points in pixels
% rgb_grid_x {N}[2xP] cell array of corner points in world coordinates
%
% K [3x3] calibrated intrinsics matrix
% kc [1x5] calibrated distortion coefficients
% R {N}[3x3] cell array of calibrated world to camera rotations
% t {N}[3x1] cell array of calibrated world to camera translations
% error_var [1] variance of corner reprojection error (in pixels)
%
% Kinect calibration toolbox by DHC
function [K,kc,R,t,error_var,error]=rgb_calib(K0,kc0,R0,t0,rgb_grid_p,rgb_grid_x, use_fixed_intrinsic)

  if(~exist('use_fixed_intrinsic','var'))
    use_fixed_intrinsic = false;
  end

  %Encode params
  params0 = [];
  params0.K = K0;
  params0.kc = kc0;
  params0.R = R0;
  params0.t = t0;
  raw0 = rgb_calib_p2r(params0, use_fixed_intrinsic);

  %Minimize
  minimization_options=optimset('LargeScale','off',...
    'Algorithm','levenberg-marquardt',...
    'Display','iter', ...
    'TolFun',1e-4,...
    'TolX',1e-8,...
    'MaxFunEvals',20000,...
    'MaxIter',1000);
%     'OutputFcn', @my_output_fcn, ...

  fprintf('Corner-based calibration - non-linear minimization over %d parameters...\n',length(raw0));
  tStart = tic();
  [raw_final,~,error] = lsqnonlin(@(x) rgb_calib_cost(x,params0,rgb_grid_p,rgb_grid_x,use_fixed_intrinsic),raw0,[],[],minimization_options);
  tElapsed = toc(tStart);
  display(['Done ' num2str(tElapsed) 's']);

  params_final = rgb_calib_r2p(raw_final,params0, use_fixed_intrinsic);
  K = params_final.K;
  kc = params_final.kc;
  R = params_final.R;
  t = params_final.t;
  error_var = var(error);
end

function res=my_output_fcn(cost,optimValues,state)
  fprintf('.');
  res = false;
end