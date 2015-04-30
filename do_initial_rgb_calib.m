%do_initial_rgb_calib()
% UI function
% Kinect calibration toolbox by DHC
function do_initial_rgb_calib(do_joint_calib,use_fixed_init)

%Inputs
global dataset_path rfiles
global rgb_grid_p rgb_grid_x
%Outputs
global calib0



%Check previous steps
%Check previous steps
if(isempty(rgb_grid_p))
    do_select_rgb_corners();
end

for k=1:length(rfiles)
    if(isempty(rgb_grid_p{k}))
        do_select_rgb_corners();
    end
end

if(~isempty(calib0.rK))
    return;
end

fprintf('-------------------\n');
fprintf('Initial RGB camera calibration\n');
fprintf('-------------------\n');

if (nargin < 1)
    do_joint_calib = false;
end

if(nargin < 2)
    use_fixed_init = false;
end

ccount = length(rgb_grid_p);

%Rext = cell(1,ccount);
%text = cell(1,ccount);
kc0 = zeros(1,5);

%Independent camera calibration
for k = 1:length(rgb_grid_p)
  fprintf('Color camera #%d\n',k);
  
  i = find(~cellfun(@isempty,rfiles{k}),1,'first');
  im = imread([dataset_path rfiles{k}{i}]);
  
  if(k==1)
    [calib0.rK{k},calib0.rkc{k},calib0.Rext,calib0.text,calib0.color_error_var(k)] = do_initial_calib(rgb_grid_p{k},rgb_grid_x{k},size(im),kc0,use_fixed_init);
    calib0.rR{k} = eye(3);
    calib0.rt{1} = zeros(3,1);
  else
    [calib0.rK{k},calib0.rkc{k},Rext,text,calib0.color_error_var(k)] = do_initial_calib(rgb_grid_p{k},rgb_grid_x{k},size(im),kc0,use_fixed_init);
    [calib0.rR{k},calib0.rt{k}] = do_initial_relative_transform(calib0.Rext,calib0.text,Rext,text);
  end

end

%Print calibration results
for k = 1:length(rgb_grid_p)
  fprintf('\nInitial calibration for camera %d:\n',k);
  
  print_calib_color(k,calib0);
  
  %Reproject
  error_abs=[];
  error_rel=[];
  for i=find(~cellfun(@(x) isempty(x),rgb_grid_p{k}))
    X = rgb_grid_x{k}{i};

%     p_abs = project_points_k(X,calib0.rK{k},calib0.rkc{k},Rext{k}{i},text{k}{i});
%     errori = p_abs-rgb_grid_p{k}{i};
%     errori = sum(errori.^2,1).^0.5;
%     error_abs = [error_abs, errori];

    R = calib0.rR{k}'*calib0.Rext{i};
    t = calib0.rR{k}'*(calib0.text{i} - calib0.rt{k});
    
    p_rel = project_points_k(X,calib0.rK{k},calib0.rkc{k},R,t);
    errori = p_rel-rgb_grid_p{k}{i};
    
%     errori = sum(errori.^2,1).^0.5;
%     error_rel = [error_rel, errori];
    error_rel = [error_rel; errori(:)];
  end
  %fprintf('Mean reprojection error with absolute Rt: %f\n',mean(error_abs));
  fprintf('Reprojection error std. dev.: %f\n',std(error_rel));
end