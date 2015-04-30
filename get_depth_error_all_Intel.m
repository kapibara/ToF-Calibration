function [errors,image_mean,image_std]=get_depth_error_all_Intel(calib,path,dfiles,depth_plane_mask)
  icount = length(dfiles);
  total_count = sum( cellfun(@(x) sum(x(:)), depth_plane_mask) );
  
  errors = zeros(total_count,1);
  
  image_mean = nan(1,icount);
  image_std = nan(1,icount);
  
  base = 1;
  for i=find(~cellfun(@isempty,dfiles))
    [points,disparity] = get_depth_samples(path,dfiles{i},depth_plane_mask{i});
    if(size(points,2) == 0)
      continue;
    end
    
    error_i = get_depth_error_Intel(calib,points,disparity,calib.Rext{i},calib.text{i});
    image_mean(i) = mean(error_i);
    image_std(i) = std(error_i);
    
    errors(base:base+length(error_i)-1) = error_i;
    base = base+length(error_i);
  end;
  
  errors = errors(1:base-1); %Not all pixels in mask have disparity
end