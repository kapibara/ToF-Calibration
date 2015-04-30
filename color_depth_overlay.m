function color_depth_overlay(calib,rgbfile,depthfile)

    Irgb = imread(rgbfile);
    Id = double(imread(depthfile));
    
    [p1,p2] = meshgrid(1:size(Id,2),1:size(Id,1));
    p = [p1(:)'; p2(:)'];
    
    
    Idcorr = correct_depth(p, Id(:)', calib);
    
    %Idcorr = Id(:)';

    valid = (Id(:)~=0);
    
    %set incorrect values back
    Idcorr(~valid) = 0;
    Idcorr(Idcorr<0) = 0;
    
    %undistorted normalized coordinates
    pr = depth2rgb(p,Idcorr(:)',calib);
    
    I = zeros(size(Irgb,1),size(Irgb,2));
    pr = round(pr)+1;
    inval = pr(2,:)<1 | pr(1,:)<1 |pr(2,:)>size(I,1) |pr(1,:)>size(I,2);
    
    
    I(sub2ind(size(I),pr(2,~inval),pr(1,~inval))) = Idcorr(~inval);
    %bring front-to-front
    Inv=max(max(I))-I;
    Inv = Inv .* (I~=0);
    I = imdilate(Inv,strel('disk',2));
    
    
    figure(5)
    clf;
    h = imshow(Irgb,'Border','tight');
    hold on
    h2 = imshow(I,[],'Border','tight');set(h2,'AlphaData',0.5)
    colormap(jet)
    figure(2)
    clf;
    h = imshow(Id/max(max(Id)),'Border','tight');
    colormap(jet)
end

%% from depth to world
