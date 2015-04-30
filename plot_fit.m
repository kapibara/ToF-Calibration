function plot_fit(inputs, res, h)

    N = 20;

    mininp = min(inputs,[],2);
    maxinp = max(inputs,[],2);
    
    %assume 2 dimensions
    delta = (maxinp -  mininp)/N;
    
    [X1,X2]=meshgrid(mininp(1):delta(1):maxinp(1),mininp(2):delta(2):maxinp(2));
    
    p = [X1(:)'; X2(:)'];
    
    R = gaussian_kern_reg(p,inputs,res, h);
    
    R = reshape(R,size(X1));
    
    surf(X1,X2,R);

end