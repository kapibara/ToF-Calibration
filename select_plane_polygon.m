%polygon=select_plane_polygon(imd)
% UI function. Asks the user to select the polygon enclosing the
% calibration plane in the depth image.
%
% Kinect calibration toolbox by DHC
function polygon=select_plane_polygon(imd)

display('Select corners of polygon enclosing plane points');
display('[left=add corner,ESC=remove corner,right=end]');

polygon = [];

[height,width] = size(imd);
im_rgb = visualize_disparity(imd);

[uu,vv] = meshgrid(0:width-1,0:height-1);
mask_img = cat(3, 0*ones(height,width),1*zeros(height,width),0*ones(height,width));

figure(1);
clf;
done = false;
while(~done)
  imshow(im_rgb,'Border','tight');
  title('Select corners of polygon enclosing plane points [left=add corner,ESC=remove corner,right=end]');
  hold on
  if(size(polygon,2) > 0)
    plot(polygon(1,:),polygon(2,:),'ow','LineWidth',2);
  end
  if(size(polygon,2) > 1)
    plot([polygon(1,:) polygon(1,1)],[polygon(2,:) polygon(2,1)],'-w','LineWidth',2);
  end
  if(size(polygon,2) > 2)
    mask = inpolygon(uu,vv,polygon(1,:),polygon(2,:)) & ~isnan(imd);
    [x,y] = find(mask==1);
    %h = imshow(mask_img);
    %set(h,'AlphaData',0.3*mask);
    plot(y,x,'+r')
  end
  hold off

  [x,y,b] = ginput(1);
  if(b == 1)
    %Left mouse button
    polygon = [polygon, [x;y]];
  elseif(b==3)
    %Right mouse button
    done = true;
  elseif(b==27)
    %ESC key
    if(size(polygon,2) > 0)
      polygon = polygon(:,1:end-1);
    end
  end
end

%Adjust to zero based coordinates.
polygon = polygon-1;