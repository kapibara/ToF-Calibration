%print_calib_color(depth_calib,depth_calib_error)
% Prints depth calibration info. 
% depth_calib_error is optional
%
% Kinect calibration toolbox by DHC
function print_calib_depth(depth_calib,depth_calib_error)

if(nargin < 2)
  depth_calib_error = [];
end

fprintf('Depth internals:\n');
fprintf('  Focal length:    [%3.2f   %3.2f]\n', ...
  depth_calib.dK(1,1),depth_calib.dK(2,2));
if(~isempty(depth_calib_error))
fprintf('                  �[%3.2f   %3.2f]\n', ...
  depth_calib_error.dK(1,1),depth_calib_error.dK(2,2));
end

fprintf('  Principal point: [%3.2f   %3.2f]\n', ...
  depth_calib.dK(1,3),depth_calib.dK(2,3));
if(~isempty(depth_calib_error))
fprintf('                  �[%3.2f   %3.2f]\n', ...
  depth_calib_error.dK(1,3),depth_calib_error.dK(2,3));
end

fprintf('  Distortion:      [%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
  depth_calib.dkc);
if(~isempty(depth_calib_error))
fprintf('                  �[%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
  depth_calib_error.dkc);
end

% fprintf('  Depth params:    [%3.6f   %3.2f   %3.4f]\n', ...
%   depth_calib.dc);
if(isfield(depth_calib,'dc') && ~isempty(depth_calib.dc))
    fprintf('  Depth params:    [%3.2f   %3.6f]\n', ...
        depth_calib.dc);
    if(~isempty(depth_calib_error))
% fprintf('                    �[%3.6f   %3.2f   %3.4f]\n', ...
%   depth_calib_error.dc);
        fprintf('                  �[%3.6f   %3.2f]\n', ...
                depth_calib_error.dc);
    end
end

if(isfield(depth_calib,'dc_alpha')  && ~isempty(depth_calib.dc_alpha)) 
    fprintf('  Depth distortion alpha:    [%3.4f   %3.4f]\n', ...
        depth_calib.dc_alpha);
    if(~isempty(depth_calib_error))
        fprintf('                            �[%3.4f   %3.4f]\n', ...
                depth_calib_error.dc_alpha);
    end
end


fprintf('Relative pose:\n');
fprintf('  Rotation:    [%3.5f   %3.5f   %3.5f;\n', ...
  depth_calib.dR(1,:));
fprintf('                %3.5f   %3.5f   %3.5f;\n', ...
  depth_calib.dR(2,:));
fprintf('                %3.5f   %3.5f   %3.5f]\n', ...
  depth_calib.dR(3,:));
%if(exist('depth_calib_error','var'))
% fprintf('               �[%3.5f   %3.5f   %3.5f]\n', ...
%   depth_calib_error.Rrel);
%end

fprintf('  Translation: [%3.5f   %3.5f   %3.5f]\n', ...
  depth_calib.dt);
if(~isempty(depth_calib_error))
fprintf('              �[%3.5f   %3.5f   %3.5f]\n', ...
  depth_calib_error.dt);
end
