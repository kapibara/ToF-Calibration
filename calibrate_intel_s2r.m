function raw_params = calibrate_intel_s2r(params)
    image_count = length(params.cRext);
    raw_params = [];
    base = 1;
    
    for i=1:5
        raw_params(base) = params.ckc(i);
        base = base+1;
    end
    
    raw_params(base:base+3) = [params.cK(1,1) params.cK(2,2) params.cK(1,3) params.cK(2,3)];
    base = base+4;

    for i=1:image_count
        if(~isempty(params.cRext{i}))
            raw_params(base:base+2) = rotationpars(params.cRext{i});
            base = base+3;
      
            raw_params(base:base+2) = params.ctext{i};
            base = base+3;
        end
    end
    
    if(isfield(params,'cR'))
        raw_params(base:base+2) = rotationpars(params.cR);
        base = base+3;
        raw_params(base:base+2) = params.ct;
    end
end