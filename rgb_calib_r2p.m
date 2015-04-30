%params=rgb_calib_r2p(raw,params0,use_fixed_intrinsic)
% Used by rgb_calib()
% Kinect calibration toolbox by DHC
function params=rgb_calib_r2p(raw,params0,use_fixed_intrinsic)

params = params0;
base = 1;

if(~use_fixed_intrinsic)
  %Internal matrix
  params.K = [raw(base) 0 raw(base+2);
    0 raw(base+1) raw(base+3);
    0 0 1];
  base = base+4;

  %Distortion coefficients
  count = min([4 length(params0.kc)]);
  params.kc = [raw(base:base+count-1) zeros(1,5-count)];
  base = base+count;
end

%Extrinsics
params.R = cell(size(params0.R));
for i=find(~cellfun(@(x) isempty(x),params0.R))
  R = rotationmat(raw(base:base+2));
  params.R{i} = R;
  base = base+3;
  params.t{i} = raw(base:base+2)';
  base = base+3;
end