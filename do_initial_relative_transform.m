function [rR,rt] = do_initial_relative_transform(Rext0,text0,Rext,text)

    rcount = length(Rext0);

    rR = zeros(3,rcount);
    rt = zeros(3,rcount);
    for i=find(~(cellfun(@(x) isempty(x),Rext) | cellfun(@(x) isempty(x),Rext0)))
      Ri = Rext0{i}*Rext{i}';
      rR(:,i) = rotationpars( Ri );
      rt(:,i) = text0{i} - Ri*text{i};
    end
    rR = rotationmat( mean(rR,2) );
    rt = mean(rt,2);

end