function [N,d] = points2plane(p)
    X = [p; ones(1,size(p,2))]';
    [U,S,V] =svd(X,'econ');
    N = V(1:3,4);
    d = V(4,4);
    
    d = -d/norm(N);
    N = N/norm(N);
    
    if(d<0) 
        d = -d;
        N = -N;
    end
end