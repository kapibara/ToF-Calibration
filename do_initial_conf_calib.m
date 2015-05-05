function conf_error_var = do_initial_conf_calib(use_fixed_init)

global dataset_path cfiles 
global conf_grid_p conf_grid_x 
global calib0

if(isempty(conf_grid_p))
    do_select_conf_corners();
end

if(~isempty(calib0.cK))
    conf_error_var = 0;
    return
end

fprintf('-------------------\n');
fprintf('Initial Depth confidence camera calibration\n');
fprintf('-------------------\n');

if(nargin < 1)
  use_fixed_init = false;
end

kc0 = zeros(1,5);

i = find(~cellfun(@isempty,cfiles),1,'first');
im = imread([dataset_path cfiles{i}]);

[calib0.cK,calib0.ckc,calib0.cRext,calib0.ctext,conf_error_var]  = do_initial_calib(conf_grid_p,conf_grid_x,size(im),kc0,use_fixed_init);
calib0.cR = eye(3,3);
calib0.ct = zeros(3,1);

fprintf('\nInitial calibration for depth camera\n');
  
print_calib_conf(calib0);
  
  %Reproject

error_rel=[];
indices = find(~cellfun(@(x) isempty(x),conf_grid_p));
for i=1:length(indices);
    X = conf_grid_x{indices(i)};

    R = calib0.cR'*calib0.cRext{indices(i)};
    t = calib0.cR'*(calib0.ctext{indices(i)} - calib0.ct);
    
    p_rel = project_points_k(X,calib0.cK,calib0.ckc,R,t);
    errori = p_rel-conf_grid_p{indices(i)};

    error_rel = [error_rel; errori(:)];
    
end
fprintf('Reprojection error mean: %f\n',mean(error_rel));
fprintf('Reprojection error std. dev.: %f\n',std(error_rel));
end