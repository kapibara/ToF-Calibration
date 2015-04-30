%p=project_points_k(X,K,kc,R,t)
% Projects a series of points onto the image plane
%
% X [3xP] points in world coordinate frame
% K [3x3] intrinsics matrix
% kc [1x5] distortion coefficients
% R [3x3] world to camera rotation
% t [3x1] world to camera translation
% p [2xP] points in pixel coordinates
%
% Kinect calibration toolbox by DHC
function p=project_points_k(X,K,kc,R,t)

if(~exist('kc','var'))
  kc = [0 0 0 0 0];
elseif(length(kc) < 5)
  kc = [kc zeros(1,5-length(kc))];
end

if(~exist('R','var'))
  R = eye(3);
end
if(~exist('t','var'))
  t = zeros(3,1);
end

count = size(X,2);

if(size(X,1)~=3)
  error('project_points_k:inputs','Points X must be 3D.');
end

Xc = bsxfun(@plus,R*X,t);
%Normalize
Xn = bsxfun(@rdivide,Xc(1:2,:),Xc(3,:));


%Project to image plane
% Xp = [K(1,1)*Xn(1,:) + K(1,3);
%      K(2,2)*Xn(2,:) + K(2,3)];
% 
% if(any(kc))
%   %Distort
%   p = distort(Xp,kc);
% else
%   p = Xp;
% end 

if(any(kc))
  %Distort
  Xd = distort(Xn,kc);
else
  Xd = Xn;
end 

p = [K(1,1)*Xd(1,:) + K(1,3);
      K(2,2)*Xd(2,:) + K(2,3)];