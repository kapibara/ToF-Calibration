%[N,d]=extrinsic2plane(R,t)
% Extracts calibration plane parameters (normal and distance from origin) 
% from the extrinsics.
%
% Kinect calibration toolbox by DHC
function [N,d]=extrinsic2plane(R,t)
  N = R(:,3);
  d = dot(R(:,3),t);

