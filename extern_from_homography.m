function [R,t] = extern_from_homography(K,H)
  R0(:,1) = K\H(:,1);
  R0(:,2) = K\H(:,2);
  lambda = 1/norm(R0(:,1));
  R0(:,1:2) = lambda*R0(:,1:2);
  R0(:,3) = cross(R0(:,1),R0(:,2));
  [U,~,V] = svd(R0);
  R = U*V';
  t = lambda*(K\H(:,3));
  
%   u1 = H(:,1);
%   u1 = u1 / norm(u1);
%   u2 = H(:,2) - dot(u1,H(:,2)) * u1;
%   u2 = u2 / norm(u2);
%   u3 = cross(u1,u2);
%   RRR = [u1 u2 u3];
%   omckk = rodrigues(RRR);
% 
%   %omckk = rodrigues([H(:,1:2) cross(H(:,1),H(:,2))]);
%   R = rodrigues(omckk);
%   t = H(:,3);