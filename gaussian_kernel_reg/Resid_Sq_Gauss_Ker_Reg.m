function [ resid_sq ] = Resid_Sq_Gauss_Ker_Reg( h,x,y,xt,yt )

ys = zeros(size(yt));

for i=1:size(xt,2)
    ys(i)=gaussian_kern_reg(xt(:,i),x,y,h);
end
e=(yt-ys);
resid_sq = e*e';

end

