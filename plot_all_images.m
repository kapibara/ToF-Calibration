function plot_all_images(dataset_path,rfiles,dfiles)

ccount = length(rfiles);
icount = length(dfiles);

rows = floor(icount^0.5);
cols = ceil(icount/rows);
for k=1:ccount
  figure(k);
  clf;
  haxes = tight_subplot(rows,cols,0.01,0,0);
  
  for i=1:icount
    axes(haxes(i));
    if(~isempty(rfiles{k}{i}))
      imshow([dataset_path rfiles{k}{i}]);
      h=text(320,240,num2str(i));
      set(h,'Color',[1,1,0],'FontWeight','bold');
    else
      imshow(0);
    end
  end
end

figure(ccount+1);
clf;
haxes = tight_subplot(rows,cols,0.01,0,0);
for i=1:icount
  axes(haxes(i));
  if(~isempty(dfiles{i}))
    imd = read_disparity([dataset_path dfiles{i}]);
    imshow(visualize_disparity(imd));
    h=text(320,240,num2str(i));
    set(h,'Color',[1,1,0],'FontWeight','bold');
  else
    imshow(0);
  end
end

