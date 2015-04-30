%H=homography_from_corners(p,x)
% Builds a homography from two corresponding point lists. 
%
% p [2xP]
% x [2xP]
% H [3x3] p=H*x (up to scale)
%
% Kinect calibration toolbox by DHC
function H=homography_from_corners(p,x)

if(size(p,1) > 2)
  p = p(1:2,:) ./ repmat(p(3,:),2,1);
end
if(size(x,1) > 2)
  x = x(1:2,:);
end
count = size(p,2);
assert(count==size(x,2));

%Normalize
pm = mean(p,2);
pdist = mean( sum((p - repmat(pm,1,count)).^2,1).^0.5 );
pscale = 2^0.5/pdist;
Tp = [eye(2)*pscale, -pm*pscale; 0 0 1];
% Tp = eye(3);
pn = Tp*[p; ones(1,count)];

xm = mean(x,2);
xdist = mean( sum((x - repmat(xm,1,count)).^2,1).^0.5 );
xscale = 2^0.5/xdist;
Tx = [eye(2)*xscale, -xm*xscale; 0 0 1];
% Tx = eye(3);
xn = Tx*[x; ones(1,count)];

%Constraints
A = zeros(2*count,9);
for i=1:count
  A(i*2-1, 4:6) = -pn(3,i)*xn(:,i)';
  A(i*2-1, 7:9) = pn(2,i)*xn(:,i)';

  A(i*2, 1:3) = pn(3,i)*xn(:,i)';
  A(i*2, 7:9) = -pn(1,i)*xn(:,i)';
end

[~,~,v] = svd(A);
h = v(:,end);
Hn = reshape(h,[3,3])';
H = inv(Tp)*Hn*Tx;
H = H/norm(H(:,1));