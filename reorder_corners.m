function [pp,xx,corner_count_x]=reorder_corners(p,dx)
  count = size(p,2);
  if(count == 0)
    pp = [];
    xx = [];
    return
  end
  if(size(p,1)~=2)
    error('p must be 2xN');
  end
  
  p(3,:) = 1;
  
  %Origin corner
  ptemp = p;
  
  [~,i] = min(ptemp(1,:));
  pref = ptemp(:,i);
  ptemp(:,i) = [];

  [p1,i] = nearest_point(pref,ptemp);
  ptemp(:,i) = [];
  [line1,pline1,ptemp]=extract_line(pref,p1,ptemp);

  [p2,i] = nearest_point(pref,ptemp);
  ptemp(:,i) = [];
  [line2,pline2,ptemp]=extract_line(pref,p2,ptemp);

  [p3,i] = nearest_point(pref,ptemp);
  ptemp(:,i) = [];
  [line3,pline3,ptemp]=extract_line(pref,p3,ptemp);

  [~,i] = max(abs([line1(1),line2(1),line3(1)]));
  if(i==1)
    pline = pline1;
  elseif(i==2)
    pline = pline2;
  else
    pline = pline3;
  end

  %Find topmost along line
  [~,i] = min(pline(2,:));
  pref = pline(:,i);
  pline(:,i) = []; %Remove origin from line for next step
  
  i = point_idx(pref,p); %recover index
  pp = pref;
  xx = [0;0;0];
  p(:,i) = [];

  %Find first horizontal line
  ptemp = p;
  i = point_idx(pline,ptemp);
  ptemp(:,i) = [];
  
  [~,i] = min(ptemp(2,:));
  p1 = ptemp(:,i);
  ptemp(:,i) = [];
  [line,pline] = extract_line(pref,p1,ptemp);

  %Add line
  corner_count_x = size(pline,2);
  dist2 = sum(bsxfun(@minus,pline,pref).^2);
  [~,i]=sort(dist2);
  pline = pline(:,i);

  xi=1;
  yi=0;
  for i=2:size(pline,2)
    [~,i] = nearest_point(pline(:,i),p);
    pp = [pp, p(:,i)];
    xx = [xx, dx*[xi;yi;0]];
    xi = xi+1; 
    p(:,i) = [];
  end
  
  %Add other lines
  yi=1;
  while(~isempty(p))
    %Get initial guess for next line
    ptemp = p;
    [p1,i] = nearest_point(pref,ptemp);
    ptemp(:,i) = [];
    
    line = adjust_line(line,p1);
    [p2,i] = nearest_in_line(line,ptemp);
    ptemp(:,i) = [];
    
    %Get line
    [line,pline] = extract_line2(p1,p2,ptemp,corner_count_x);
    
    %Check corner count
    if(corner_count_x ~= size(pline,2))
      error('Found lines of different length!');
    end
    
    %Add all points on the line
    [~,i]=sort(pline(1,:));
    pline = pline(:,i);
    
    xi=0;
    for i=1:size(pline,2)
      [~,i] = nearest_point(pline(:,i),p);
      pp = [pp, p(:,i)];
      xx = [xx, dx*[xi;yi;0]];
      xi = xi+1; 
      p(:,i) = [];
    end

    pref = pline(:,1); %save for next line
    yi=yi+1;
  end

  pp = pp(1:2,:);
end

function idx=point_idx(p,pset)
  pcount = size(p,2);
  idx = zeros(1,pcount);
  for i=1:pcount
    e = pset(1,:) == p(1,i) & pset(2,:) == p(2,i);
    idx_i = find(e);
    if(isempty(idx_i))
      warning('point_not_found','Point not found.');
    elseif(length(idx_i)>1)
      warning('many_points','Many points found.');
    else
      idx(i) = idx_i;
    end
  end
end

function [pnearest,idx]=nearest_point(pref,p)
    dif = bsxfun(@minus,p,pref);
    dist = sum(dif.^2,1);
    [~,idx] = min(dist);
    pnearest = p(:,idx);
end

function line=points2line(pline)
  %This works for two points
  %line = cross(p1,p2);
  %line = line/norm(line(1:2));
  
  %This works for many points
  [~,~,V]=svd(pline');
  line = V(:,end) / norm(V(1:2,end));
end

function [p,idx,dist] = nearest_in_line(line,pp)
  %Distance to line
  fits_temp = abs(sum( bsxfun(@times, pp, line) ));
  [~,idx] = min(fits_temp);
  
  p = pp(:,idx);
  dist = fits_temp(idx);
end

function [line,pline,pp]=extract_line(pref,p2,p)
    %Start line with two points
    pp = p;
    pline = [pref,p2];
    
    %dist_ref = sqrt(sum((pref-p2).^2));    
    %fit_threshold = dist_ref/10;

    line = points2line(pline);
    line_found=false;
    
    %Add points to line
    while(~line_found && size(pp,2)>0)
      %Calculate line with new point
      [~,i] = nearest_in_line(line,pp);
      pline2 = [pline,pp(:,i)];
      nline = points2line(pline2);
      
      %Calculate threshold
      dist_ref = sqrt(sum(bsxfun(@minus,pref,pline2(:,2:end)).^2));
      fit_threshold = min(dist_ref)/10;
      
      %Check that all points fit
      fits_prev = abs(sum( bsxfun(@times, pline2, nline) )) < fit_threshold;
      if(~all(fits_prev))
        line_found = true;
      else
        line = nline;
        pline = pline2;
        
        pp(:,i) = [];
      end
    end
end

%This version extracts a line with the given point count
function [line,pline,pp]=extract_line2(pref,p2,p,min_pcount)
    if(size(p,2)+2 < min_pcount)
      error('Insufficient points to construct line.');
    end
    
    %Start line with two points
    pp = p;
    pline = [pref,p2];
    
    %dist_ref = sqrt(sum((pref-p2).^2));    
    %fit_threshold = dist_ref/10;

    line = points2line(pline);
    
    %Add points to line
    while(size(pline,2)<min_pcount)
      %Calculate line with new point
      [~,i] = nearest_in_line(line,pp);
      pline = [pline,pp(:,i)];
      line = points2line(pline);
      pp(:,i) = [];
    end
end

function line=adjust_line(line0,pref)
  res = line0(1:2)'*pref(1:2);
  line = [line0(1:2); -res];
end