%im_rgb=visualize_disparity(im)
% Creates a visualization rgb image from a disparity image
%
% Kinect calibration toolbox by DHC
function im_rgb=visualize_disparity(im)

if(size(im,3) == 1)
  im_rgb = mat2rgb(im,jet(256));

  s = [1 2 1; 0 0 0; -1 -2 -1];
  dx = imfilter(im,s,'replicate','same');
  dy = imfilter(im,s','replicate','same');
  dm = (dy.^2 + dx.^2).^0.5;
  dm = min(dm,20)/20;
  im_rgb = repmat(dm,[1,1,3]).*im_rgb;
else
  im_rgb = im;
end
