%compute relativa transformation based on the set of planes, defined by
%rotations and translations;

function [R,t] = estimate_plane_to_plane(Rext1,text1,Rext2,text2)
  good = find(cellfun(@(x) ~isempty(x),Rext1) & cellfun(@(x) ~isempty(x),Rext2));
  
  planeN1 = zeros(3,2);
  planed1 = zeros(1,length(good));
  for i=1:length(good)
      %transform (R,t) -> (N,d)
      [planeN1(:,i), planed1(i)] = extrinsic2plane(Rext1{good(i)},text1{good(i)});
  end

  planeN2 = zeros(3,2);
  planed2 = zeros(1,length(good));
  for i=1:length(good)
      %transform (R,t) -> (N,d)
      [planeN2(:,i), planed2(i)] = extrinsic2plane(Rext2{good(i)},text2{good(i)}); 
      %correct the sign
      planeN2(:,i) = sign(planed1(i)).*sign(planed2(i)).*planeN2(:,i);
      planed2(i) = sign(planed1(i)).*sign(planed2(i)).*planed2(i); 
  end
  
  t = pinv(planeN1*planeN1')*planeN1*(planed1-planed2)';
  [u,~,v] = svd(planeN2*planeN1');
  R = v*u';
end