%[K,R,t]=calib_from_homographies(H)
%Computes calibration parameters using homographies
%Implemented directly from Zhang's '99 paper
% "Flexible Camera Calibration By Viewing a Plane From Unknown
% Orientations"
%
% H is a cell array of 3x3 homographies
% K is the [3x3] intrinsics matrix
% R is a cell array of 3x3 rotations
% t is a cell array of 3x1 translations
%
% Kinect calibration toolbox by DHC
function [K,R,t]=calib_from_homographies(H)
  vH = H(~cellfun(@(x) isempty(x),H));
  hcount = length(vH);
  V = zeros(2*hcount,6);

  for i=1:hcount
    Hi = vH{i}/norm(vH{i}(:,1));
    V(2*i-1,:) = vij(Hi,1,2)';
    V(2*i,:) = (vij(Hi,1,1)-vij(Hi,2,2))';
  end
  
  [~,~,vv] = svd(V,0);
  b = vv(:,end); %b = [B11,B12,B22,B13,B23,B33]T
    
  %v0 = (B12B13 ? B11B23)/(B11B22 ? B212)
  v0 = (b(2)*b(4)-b(1)*b(5)) / (b(1)*b(3)-b(2)^2);
  %? = B33 ? [B213 + v0(B12B13 ? B11B23)]/B11
  lambda = b(6) - (b(4)^2+v0*(b(2)*b(4)-b(1)*b(5)))/b(1);
  %? =sqrt ?/B11
  alpha = (lambda/b(1))^0.5;
  %? =sqrt ?B11/(B11B22 ? B212)
  beta = (lambda*b(1)/(b(1)*b(3)-b(2)^2))^0.5;
  %c = ?B12?2?/?
  c = -b(2)*alpha^2*beta/lambda;
  %u0 = cv0/? ? B13?2/? .
  u0 = c*v0/alpha-b(4)*alpha^2/lambda;
  
  K = [alpha c u0; 0 beta v0; 0 0 1];
  
  R0 = zeros(3,3);
  R = cell(1,length(H));
  t = cell(1,length(H));
  for i=find(~cellfun(@(x) isempty(x),H))
%     R0(:,1) = K\H{i}(:,1);
%     R0(:,2) = K\H{i}(:,2);
%     lambda = 1/norm(R0(:,1));
%     R0(:,1:2) = lambda*R0(:,1:2);
%     R0(:,3) = cross(R0(:,1),R0(:,2));
%     [U,~,V] = svd(R0);
%     R{i} = U*V';
%     t{i} = lambda*(K\H{i}(:,3));
    [R{i},t{i}] = extern_from_homography(K,H{i});
  end
end

function v=vij(H,i,j)
  v = [H(1,i)*H(1,j), H(1,i)*H(2,j)+H(2,i)*H(1,j), H(2,i)*H(2,j), ...
    H(3,i)*H(1,j)+H(1,i)*H(3,j), H(3,i)*H(2,j)+H(2,i)*H(3,j), H(3,i)*H(3,j)]';
end