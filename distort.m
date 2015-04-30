%Xd = distort(Xn,kc)
% Distorts points according to the Heikkila's distortion model (same used
% by Bouguet's toolbox).
% 
% Xn [2xP] normalized points (already divided by Z component)
% kc [1x5] distortion coefficients
% Xd [2xP] distorted points
% 
% Kinect calibration toolbox by DHC
function Xd = distort(Xn,kc)

if(size(Xn,1) ~= 2)
  error('distort:inputs','Xn should be [2xN]');
end

%Distort
r2 = Xn(1,:).^2+Xn(2,:).^2;
rc = 1 + kc(1)*r2 + kc(2)*r2.^2 + kc(5)*r2.^3;
rc = repmat(rc,2,1);
dx = [2*kc(3)*Xn(1,:).*Xn(2,:) + kc(4)*(r2 + 2*Xn(1,:).^2);
      kc(3)*(r2 + 2*Xn(2,:).^2) + 2*kc(4)*Xn(1,:).*Xn(2,:)];
Xd = rc.*Xn + dx;
