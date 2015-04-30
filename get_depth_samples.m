function [points,disparity]=get_depth_samples(path,dfiles,masks)
  cell_input = iscell(dfiles);
  if(~cell_input)
    dfiles = {dfiles};
    masks = {masks};
  end
  
  icount = length(dfiles);
  
  points = cell(1,icount);
  disparity = cell(1,icount);
  
  for i=1:icount
    if(isempty(dfiles{i}))
      points{i} = zeros(2,0);
      disparity{i} = zeros(1,0);
    else
      imd = read_disparity([path dfiles{i}]);

      [points{i}(2,:),points{i}(1,:)] = ind2sub(size(masks{i}),find(masks{i})');
      points{i} = points{i}-1; %Zero based
      disparity{i} = imd(masks{i})';
    end
  end
  
  %Choose cell or vector output
  if(~cell_input)
    points = points{1};
    disparity = disparity{1};
  end
end