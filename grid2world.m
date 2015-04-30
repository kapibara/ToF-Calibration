function grid = grid2world(i,calib)
    global conf_grid_x;
    
    grid = expandGrid(conf_grid_x{i});
    
    grid = calib.cRext{i}*grid + repmat(calib.ctext{i},1,size(grid,2));
end

function grid = expandGrid(grid)
    d = max(grid(2,:)); %size in first dimension
 
    dt = [0; -d; 0];
    
    grid = [(grid + repmat(2*dt,1,size(grid,2)))] ;
    
end