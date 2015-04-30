function K = precomputeKmat(x,xsnap)
    for i=1:size(x,2)
        K(:,i) = sum((xsnap-repmat(x(i,:),1,size(xsnap,2))).^2,1)/h^2;
    end
end