function params = calibrate_intel_r2s(raw_params,params0)
    params = params0;

    image_count = length(params0.cRext);
    base=1;
    
    %Distortion parameters
    for i=1:5
        params.ckc(i) = raw_params(base);
        base = base+1;
    end
    
    %Depth internal matrix
    params.cK = [raw_params(base), 0, raw_params(base+2); ...
                0, raw_params(base+1), raw_params(base+3); ...
                0, 0, 1];
    base=base+4;
    
    params.cRext = cell(1,image_count);
    params.ctext = cell(1,image_count);
    for i=1:image_count
        if(~isempty(params0.cRext{i}))
            params.cRext{i} = rotationmat(raw_params(base:base+2));
            base = base+3;
            params.ctext{i} = raw_params(base:base+2)';
            base = base+3;
        end
    end
    
    if (base < length(raw_params))
        params.cR = rotationmat(raw_params(base:base+2));
        base = base+3;
        params.ct = raw_params(base:base+2)';
        base = base+3;
    end
end