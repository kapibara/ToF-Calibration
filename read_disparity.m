%imd = read_disparity(filename)
% Reads a disparity image from disk. Corrects endianness issues. Replaces
% 'nan_value' values with NaNs. Default for nan_value is 2047.
%
% Kinect calibration toolbox by DHC
function imd = read_disparity(filename,options)

if(isfield(options,'read_image'))
  [imd,max_value]=options.read_image(filename);
else
  imd = imread(filename);
  max_value = 65535;
end

imd(imd == max_value) = 0;

%Check channel count
if(size(imd,3) > 1)
    warning('Disparity image has multiple channels; invalid format!')
end

fprintf('Disparity values: range [%d %d]\n',min(imd(:)),max(imd(:)));

%Set invalid depths to NaN
imd = double(imd);
