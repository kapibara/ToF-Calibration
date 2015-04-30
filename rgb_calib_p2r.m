%raw=rgb_calib_p2r(params,use_fixed_intrinsic)
% Used by rgb_calib()
% Kinect calibration toolbox by DHC
function raw=rgb_calib_p2r(params,use_fixed_intrinsic)

raw = [];
base = 1;

if(~use_fixed_intrinsic)
  %Internal matrix
  raw(base) = params.K(1,1);
  raw(base+1) = params.K(2,2);
  raw(base+2) = params.K(1,3);
  raw(base+3) = params.K(2,3);
  base = base+4;

  %Distortion coefficients
  count = min([4 length(params.kc)]); %Do not estimate 5th coefficient
  raw(base:base+count-1) = params.kc(1:count);
  base = base+count;
end

%Extrinsics
for i=find(~cellfun(@(x) isempty(x),params.R))
  r = rotationpars(params.R{i});
  raw(base:base+2) = r;
  base = base+3;
  raw(base:base+2) = params.t{i};
  base = base+3;
end