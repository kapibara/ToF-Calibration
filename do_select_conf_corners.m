function do_select_conf_corners()

global grid_p grid_x cfiles conf_grid_p conf_grid_x
global corner_count_x corner_count_y dx

fprintf('-------------------\n');
fprintf('Selecting conf corners\n');
fprintf('-------------------\n');

%  if(~exist('use_automatic','var'))
%        use_automatic = input('Use automatic corner detector? ([]=true, other=false)? ','s');
%        if(isempty(use_automatic))
%            use_automatic = true;
%        else
use_automatic = true;
%        end
%  end
  
if(isempty(corner_count_x))
      corner_count_x = input('Inner corner count in X direction: ');
      corner_count_y = input('Inner corner count in Y direction: ');
end
  
default = 26;
if(isempty(dx))
      dx = input(['Square size ([]=' num2str(default) 'mm): ']);
end
if(isempty(dx))
    dx = default;
end

do_select_corners_from_images(cfiles,use_automatic,dx,corner_count_x, corner_count_y);

conf_grid_p = grid_p;
conf_grid_x = grid_x;

grid_p = {};
grid_x = {};

end