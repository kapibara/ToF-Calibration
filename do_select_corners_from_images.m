function do_select_corners_from_images(files, use_automatic,dx,corner_count_x, corner_count_y)
  global grid_x grid_p dataset_path
  
  icount = length(files);

  if(~exist('use_automatic','var'))
        use_automatic = input('Use automatic corner detector? ([]=true, other=false)? ','s');
        if(isempty(use_automatic))
            use_automatic = true;
        else
            use_automatic = false;
        end
  end
  
  if(~exist('corner_count_x','var'))
      corner_count_x = input(['Inner corner count in X direction: ']);
      corner_count_y = input(['Inner corner count in Y direction: ']);
  end
  
  default = 26;
  if(~exist('dx','var'))
      dx = input(['Square size ([]=' num2str(default) 'mm): ']);
  end
  if(isempty(dx))
    dx = default;
  end
    
  default = 6;
  win_dx = input(['Corner finder window size ([]=' num2str(default) 'px): ']);
  if(isempty(win_dx))
    win_dx = default;
  end

  %Select images
  if(isempty(grid_x))
    grid_p = cell(1,icount);
    grid_x = cell(1,icount);
    fidx = 1:icount;
  else
    %Check for too small or too big array
    if(length(grid_x) ~= icount)
      grid_p{icount} = [];
      grid_x{icount} = [];
    elseif(length(grid_x) > icount)
      grid_p = grid_p(1:icount);
      grid_x = grid_x(1:icount);
    end

    %Select only missing planes
    missing = cellfun(@(x) isempty(x),grid_x) & ~cellfun(@(x) isempty(x),files);
    if(all(missing))
      fidx = 1:icount;
    else
      fidx = find(missing);
    end
  end

  
  figure(1);
  clf;
  figure(2);
  clf;

  %Extract grid for all images
  for i=fidx
    if(isempty(files{i}))
      continue
    end

    fprintf('#%d - %s\n',i,files{i});
    
    im = imread([dataset_path files{i}]);
    
    [pp,xx] = do_select_corners(im,corner_count_x,corner_count_y,dx,use_automatic,win_dx,i);
    
    grid_p{i} = pp;
    grid_x{i} = xx;

    %fprintf('Press ENTER to continue\n');
    %pause;
  end
  
  fprintf('Finished extracting corners for the selected images.\n');    
end