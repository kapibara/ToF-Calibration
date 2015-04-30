

function ys=gaussian_kern_reg(xs,x,y,h)

% Gaussian kernel function
%K=sqdist(diag(1./h)*x,diag(1./h)*xs);

K = sqdistance(diag(1./h)*x, diag(1./h)*xs);
%K = slmetric_pw(diag(1./h)*x, diag(1./h)*xs, 'sqdist');

%K = sum((x-repmat(xs,1,size(x,2))).^2,1)'/h^2;
K= exp(-K/2);

% linear kernel regression
ys = (y*K) ./ (sum(K));
