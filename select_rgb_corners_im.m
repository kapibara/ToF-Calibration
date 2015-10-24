%[p,x,win_dx]=select_rgb_corners_im(im,dx,win_dx)
% Prompts the user to select grid corners on an image.
%
% Kinect calibration toolbox by DHC
function [p,x,win_dx,b]=select_rgb_corners_im(im,dx,win_dx)
  im = mean(double(im),3);
  
  fc = [530 530];
  cc = [320 240];
  
  done = false;
  while(~done)
    hold off;
    [p,x,b] = extract_grid(im,win_dx,win_dx,fc,cc,[0 0 0 0 0],dx,dx);
    if(isempty(p))
      return;
    end
    
    %s=input('Is grid ok? ([]=y):','s');
    %if(isempty(s)); s='y'; end;
    %done = strcmp(s,'y');
    
    done = 1;
    
    if(~done)
      v = input(['Search window size ([]=' num2str(win_dx) 'px): ']);
      if(~isempty(v))
        win_dx = v;
      end
    end
  end
end
