function [ h ] = Opt_Hyp_Gauss_Ker_Reg( h0,x,y )

alpha = 0.75;

n=size(x,2);
inx=randperm(n);
N = round(n*alpha);
inx1 = inx(1:N);
inx2 = inx(N+1:n);

d=max(x')-min(x');

% h= fminsearch(@(h) Resid_Sq_Gauss_Ker_Reg(h,x(inx1),y(inx1),x(inx2),y(inx2)),h0 );
%h= fmincon(@(h) Resid_Sq_Gauss_Ker_Reg(h,x(:,inx1),y(:,inx1),x(:,inx2),y(:,inx2)),h0,[],[],[],[],d/20,2*d );
h= fmincon(@(h) Resid_Sq_Gauss_Ker_Reg(h,x(:,inx1),y(:,inx1),x(:,inx2),y(:,inx2)),h0,[],[],[],[],d/20,2*d );
% h= simulannealbnd(@(h) Resid_Sq_Gauss_Ker_Reg(h,x(inx1),y(inx1),x(inx2),y(inx2)),h0,2,100 );


end

