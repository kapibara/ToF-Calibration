%do_select_planes()
% UI function.
% Kinect calibration toolbox by DHC
function do_select_planes_Intel()

%Input
global dataset_path dfiles
%Output
global depth_plane_poly depth_plane_mask


%width = 640;
%height = 480;
Id = imread([dataset_path '/' dfiles{1}]);
width = size(Id,2);
height = size(Id,1);
icount = length(dfiles);

fprintf('-------------------\n');
fprintf('Selecting planes\n');
fprintf('-------------------\n');

%Select images
if(isempty(depth_plane_poly))
  depth_plane_poly = cell(1,icount);
  depth_plane_mask = cell(1,icount);
  fidx = 1:icount;
else
  %Check for too small or too big array
  if(length(depth_plane_poly) < icount)
    depth_plane_poly{icount} = [];
    depth_plane_mask{icount} = [];
  elseif(length(depth_plane_poly) > icount)
    depth_plane_poly = depth_plane_poly(1:icount);
    depth_plane_mask = depth_plane_mask(1:icount);
  end
  
  %Select only missing planes
  missing = cellfun(@(x) isempty(x),depth_plane_poly) & ~cellfun(@(x) isempty(x),dfiles);
  if(all(missing))
    default = 1:length(dfiles);
    fidx = input('Select images to process ([]=all): ');
  else
    default = find(missing);
    fidx = input(['Select images to process ([]=[' num2str(default) ']): ']);
  end
  if(isempty(fidx))
    fidx = default;
  end
end

%Get plane polygons for all images
[uu,vv] = meshgrid(0:width-1,0:height-1);
for i=fidx
  if(isempty(dfiles{i}))
    continue
  end
  
  fprintf('#%d - %s\n',i,dfiles{i});

  imd = read_disparity([dataset_path dfiles{i}],0);
  
  depth_plane_poly{i} = select_plane_polygon(imd);
  %Extract mask
  if(isempty(depth_plane_poly{i}))
    depth_plane_mask{i} = false(size(imd));
  else
    depth_plane_mask{i} = inpolygon(uu,vv,depth_plane_poly{i}(1,:),depth_plane_poly{i}(2,:)) & ~isnan(imd);
  end
end
fprintf('Done\n');