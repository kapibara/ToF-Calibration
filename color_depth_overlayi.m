function color_depth_overlayi(calib,i)
    global dataset_path dfiles rfiles

    color_depth_overlay(calib,[dataset_path rfiles{1}{i}],[dataset_path dfiles{i}]);
    
end