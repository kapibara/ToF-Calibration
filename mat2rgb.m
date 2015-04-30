function rgb=mat2rgb(mat, map, range)

if(nargin<3)
  range = [min(mat(:)) max(mat(:))];
end

map_length = size(map,1);

rgb = ind2rgb(round(map_length*mat2gray(mat,range)), map);
rgb(isnan(repmat(mat,[1 1 3]))) = NaN;