function [rK,rkc,Rext,text,color_error_var] = do_initial_calib(grid_p,grid_x,imsize,kc0,use_fixed_init)

  %Compute homographies for rgb images
  rcount = length(grid_p);

  if(use_fixed_init)
    
    %This is not a proper focal length estimate, but it works with the
    %kinect.
    rKc = [imsize(2), 0, imsize(2)/2; 
            0, imsize(2), imsize(1)/2;
            0,0,1];

    rRc = cell(1,rcount);
    rtc = cell(1,rcount);
    ids = find(~cellfun(@(x) isempty(x),grid_p));
    for i=1:length(ids)
      H = homography_from_corners(grid_p{ids(i)},grid_x{ids(i)});
      [rRc{ids(i)},rtc{ids(i)}] = extrinsics_from_homography(rKc,H);
    end
  else
    %Estimate intrinsics and extrinsics using homographies
    rH = cell(1,rcount);
    ids = find(~cellfun(@(x) isempty(x),grid_p));
    for i=1:length(ids)
      rH{ids(i)} = homography_from_corners(grid_p{ids(i)},grid_x{ids(i)});
    end

    %Closed form calibration using homographies
    [rKc,rRc,rtc]=calib_from_homographies(rH);
    rKc(1,2) = 0; %No skew
  end
  
  %Refine calibration using all images for this camera
  [rK,rkc,Rext,text,color_error_var,~] = rgb_calib(rKc,kc0,rRc,rtc,grid_p,grid_x,false);

  %Point camera forwards
  for i=find(~cellfun(@(x) isempty(x),Rext))
    if(text{i}(3) < 0)
      Rext{i}(:,1:2) = -Rext{i}(:,1:2);
      text{i} = -text{i};
    end
  end
  
end