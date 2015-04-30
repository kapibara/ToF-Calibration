%print_calib_color(k,depth_calib,depth_calib_error)
% Prints color calibration info. 
% depth_calib_error is optional
%
% Kinect calibration toolbox by DHC
function print_calib_color(k,depth_calib,depth_calib_error)

if(nargin < 3)
  depth_calib_error = [];
end

fprintf('Color internals:\n');
fprintf('  Focal length:    [%3.2f   %3.2f]\n', ...
  depth_calib.rK{k}(1,1),depth_calib.rK{k}(2,2));
if(~isempty(depth_calib_error))
fprintf('                   +-[%3.2f   %3.2f]\n', ...
  depth_calib_error.rK{k}(1,1),depth_calib_error.rK{k}(2,2));
end

fprintf('  Principal point: [%3.2f   %3.2f]\n', ...
  depth_calib.rK{k}(1,3),depth_calib.rK{k}(2,3));
if(~isempty(depth_calib_error))
fprintf('                    +-[%3.2f   %3.2f]\n', ...
  depth_calib_error.rK{k}(1,3),depth_calib_error.rK{k}(2,3));
end

fprintf('  Distortion:      [%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
  depth_calib.rkc{k});
if(~isempty(depth_calib_error))
fprintf('                    +-[%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
  depth_calib_error.rkc{k});
end

fprintf('Relative pose:\n');
fprintf('  Rotation:    [%3.5f   %3.5f   %3.5f;\n', ...
  depth_calib.rR{k}(1,:));
fprintf('                %3.5f   %3.5f   %3.5f;\n', ...
  depth_calib.rR{k}(2,:));
fprintf('                %3.5f   %3.5f   %3.5f]\n', ...
  depth_calib.rR{k}(3,:));
%if(exist('depth_calib_error','var'))
% fprintf('               �[%3.5f   %3.5f   %3.5f]\n', ...
%   depth_calib_error.rR{k});
%end

fprintf('  Translation: [%3.5f   %3.5f   %3.5f]\n', ...
  depth_calib.rt{k});
if(~isempty(depth_calib_error))
fprintf('               +-[%3.5f   %3.5f   %3.5f]\n', ...
  depth_calib_error.rt{k});
end
