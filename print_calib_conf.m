function print_calib_conf(calib,calib_error)

if(nargin < 2)
  calib_error = [];
end

fprintf('Confidence internals:\n');
fprintf('  Focal length:    [%3.2f   %3.2f]\n', ...
        calib.cK(1,1),calib.cK(2,2));
if(~isempty(calib_error))
    fprintf('                  [%3.2f   %3.2f]\n', ...
            calib_error.cK(1,1),calib_error.cK(2,2));
end

fprintf('  Principal point: [%3.2f   %3.2f]\n', ...
  calib.cK(1,3),calib.cK(2,3));
if(~isempty(calib_error))
    fprintf('                  [%3.2f   %3.2f]\n', ...
            calib_error.cK(1,3),calib_error.cK(2,3));
end

fprintf('  Distortion:      [%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
        calib.ckc);
if(~isempty(calib_error))
    fprintf('                  [%3.4f   %3.4f   %3.4f   %3.4f   %3.4f]\n', ...
            calib_error.ckc);
end

fprintf('Relative pose:\n');
fprintf('  Rotation:    [%3.5f   %3.5f   %3.5f;\n', ...
        calib.cR(1,:));
fprintf('                %3.5f   %3.5f   %3.5f;\n', ...
        calib.cR(2,:));
fprintf('                %3.5f   %3.5f   %3.5f]\n', ...
        calib.cR(3,:));

fprintf('  Translation: [%3.5f   %3.5f   %3.5f]\n', ...
        calib.ct);
if(~isempty(calib_error))
    fprintf('              [%3.5f   %3.5f   %3.5f]\n', ...
            calib_error.ct);
end

end