function imshowi(i,type)

global dataset_path rfiles cfiles dfiles

switch type
    case 'rgb'
        I = imread([dataset_path rfiles{1}{i}]);
        imshow(I);
    case 'conf'
        I = double(imread([dataset_path cfiles{i}]));
        imshow(I/max(max(I)));
    case 'depth'
        I = double(imread([dataset_path dfiles{i}]));
        I=visualize_disparity(I);
        imshow(I);
end

end