function [pp,xx] = do_select_corners(im,corner_count_x,corner_count_y,dx,use_automatic,win_dx,i)

    if(~exist('i','var'))
       i =0; 
    end
    
    if(~exist('dx','var'))
        dx = 0.04;
    end
    
    if(~exist('win_dx','var'))
        win_dx = 6;
    end
    
    if(~exist('use_automatic','var'))
        use_automatic = false;
    end

    if(size(im,3)==3)
      im = rgb2gray(im);
    end

    p = [];
    if(use_automatic)
%      p=click_ima_calib_rufli_k(i,im,true,win_dx,win_dx,corner_count_x-1,corner_count_y-1);
        p = detectCheckerboardPoints(im)';
    end
    
    if(isempty(p))
      [p,~,win_dx] = select_rgb_corners_im(im,dx,win_dx);
    end
    
    if(isempty(p))
      pp = [];
      xx = [];
    else
      [pp,xx,cx] = reorder_corners(p,dx);
      figure(2);
      hold off;
      if(size(im,3)==1)
          imshow(double(im)/max(max(double(im))))
      else
        imshow(im);
      end
      hold on;
      plot(pp(1,:)+1,pp(2,:)+1,'+');
      draw_axes(pp,cx);
      drawnow;
    end

end