
function calib = fit_depth_correction(calib)

%remove the previous correction estimate
if(isfield(calib,'inputs'))
    calib = rmfield(calib,'inputs');
end
%compute error accross images
[error,depthm,imxy] = compute_full_derror(calib);

d = sqrt(sum((imxy - repmat(calib.cK(1:2,3),1,size(imxy,2))).^2,1)); %distance to the image center
%remove outliers
valid = abs(error)<60 & d < 100;

calib.inputs = [depthm(valid) ; imxy(:,valid)];
calib.res = error(:,valid);

calib.inputs  = calib.inputs(calib.coords,:); 

subind = 1:1:size(calib.inputs,2);

calib.inputs = calib.inputs(:,subind);
calib.res  = calib.res(subind);

end
