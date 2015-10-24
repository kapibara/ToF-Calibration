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
      imrgb = im;
      im = rgb2gray(im);
    end
    
    if(max(max(double(im))>15000))
       %16bit confidence values
       im(im>15000) = 0;
    end
    im= double(im)/max(max(double(im)));
    p = [];
    if(use_automatic)
       figure(1);
       if(exist('imrgb','var'))
           imshow(imrgb);
       else
           imshow(im); 
       end
       hold on;
       detector = @(p,I) p; 
       
       [x,y] = get4points(im,detector,1,1);
       mask = poly2mask(x,y,size(im,1),size(im,2));
       
       im(mask==0) = 0;
       impatch = im(min(y):max(y),min(x):max(x))/max(max(im(min(y):max(y),min(x):max(x))));
       im(min(y):max(y),min(x):max(x)) = impatch;
       
       p = detectCheckerboardPoints(impatch)';
       
       if(~isempty(p))
       	p(1,:) = p(1,:)+min(x);
       	p(2,:) = p(2,:)+min(y);           
           
        figure(1); 
        cla(gca);
        imshow(im)
        hold on
        plot(p(1,:),p(2,:),'+r');
        title('If the corners are good, click left mouse button, else, click right mouse button');
        [~,~,button] = ginput(1);
        if(button~=1)
          p = [];
        end
       end
    end
    b = 1;
    while(isempty(p) && b ~=27)
       [p,~,win_dx,b] = select_rgb_corners_im(im,dx,win_dx);
        if(~isempty(p))
            figure(1); 
            cla(gca);
            imshow(im)
            hold on
            plot(p(1,:),p(2,:),'+r');     
            title('If the corners are good, click left mouse button, else, click right mouse button');
            [~,~,button] = ginput(1);
            if(button~=1)
                p = [];
            end
        end
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