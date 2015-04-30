function plot_confidence( dataset_path, cfiles )

    icount = length(cfiles);

    rows = floor(icount^0.5);
    cols = ceil(icount/rows);
    
    figure(666);
    clf;
    haxes = tight_subplot(rows,cols,0.01,0,0);
    for i=1:icount
        axes(haxes(i));
        if(~isempty(cfiles{i}))
            imd = double(imread([dataset_path cfiles{i}]));
            imshow(imd/max(max(imd)));
            h=text(320,240,num2str(i));
            set(h,'Color',[1,1,0],'FontWeight','bold');
        else
            imshow(0);
        end
    end
end

