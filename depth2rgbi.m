function prgb = depth2rgbi(calib,i,p)
    global dfiles dataset_path rfiles
    
    Id = double(imread([dataset_path dfiles{i}]));
    
    d = Id(sub2ind(size(Id),round(p(2,:))+1,round(p(1,:))+1));

    %correction is included in depth2rgb()
    prgb = depth2rgb(p,d,calib);
    
    Irgb = double(imread([dataset_path rfiles{1}{i}]));
    
    imshow(Irgb/256)
    hold on
    plot(prgb(1,:)+1,prgb(2,:)+1,'or');
    
end