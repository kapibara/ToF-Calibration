%do_select_images()
% UI function.
% Kinect calibration toolbox by DHC
function do_select_images_Intel(options)


global dataset_path rfiles rsize dfiles cfiles

fprintf('-------------------\n');
fprintf('Selecting images\n');
fprintf('-------------------\n');

s = sprintf('Path to image directory ([]=current dir):');
dataset_path = input(s,'s');
if(~isempty(dataset_path) && (dataset_path(end) ~= '\' || dataset_path(end) ~= '/'))
  dataset_path = [dataset_path '/'];
end

ccount = input('Number of color cameras ([]=1):');
if(isempty(ccount))
  ccount = 1;
end

rfile_format = cell(1,ccount);
if(options.color_present)
    for k=1:ccount
        default = 'ImRGB%03d.png';
        s = sprintf('Filename format for camera %d images ([]=''%s''):',k,default);
        rfile_format{k} = input(s,'s');
        if(isempty(rfile_format{k}))
            rfile_format{k} = default;
        end
    end
end

default = 'ImDepthOrig%03d.png';
s = sprintf('Filename format for depth images ([]=''%s''):',default);
dfile_format = input(s,'s');
if(isempty(dfile_format))
  dfile_format = default;
end

default = 'ImDepthConf%03d.png';
s = sprintf('Filename format for confidence images ([]=''%s''):',default);
cfile_format = input(s,'s');
if(isempty(cfile_format))
  cfile_format = default;
end

[rfiles,rsize,dfiles,cfiles] = find_images_Intel(options,dataset_path,rfile_format,dfile_format,cfile_format);
icount = length(dfiles);

fprintf('%d plane poses found.\n',icount);
if(icount == 0)
  return;
end

%Show thumbnails
plot_all_images(dataset_path,rfiles,dfiles);
plot_confidence( dataset_path, cfiles );

%Ask user
calib_idx=input('Select poses to use for calibration ([]=all):');
if(isempty(calib_idx))
  calib_idx = 1:icount;
end
for k=1:ccount
  rfiles{k} = rfiles{k}(calib_idx);
end
dfiles = dfiles(calib_idx);
cfiles = cfiles(calib_idx);
