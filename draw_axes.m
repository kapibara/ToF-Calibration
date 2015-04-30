%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function taken from the OCamCalib toolbox.
% Modified by Daniel Herrera C.
% - Changed plot(y,x) to plot(x,y)
function draw_axes(corners,corner_count_x)

  xo_X = corners(1,1:corner_count_x)+1;
  yo_X = corners(2,1:corner_count_x)+1;
  xo_Y = corners(1,1:corner_count_x:end)+1;
  yo_Y = corners(2,1:corner_count_x:end)+1;

  plot(xo_X, yo_X,'g-','linewidth',2);
  plot(xo_Y, yo_Y,'g-','linewidth',2);

  delta = 40;%abs((yo_X(2)-yo_X(1)))*4; %pixels

  uX = [xo_X(2)-xo_X(1);yo_X(2)-yo_X(1);0];
  uY = [xo_Y(2)-xo_Y(1);yo_Y(2)-yo_Y(1);0];

  origin = [xo_X(1);yo_X(1);0];

  Xloc = cross( uX, cross(uX,uY) ); Xloc=Xloc/abs(norm(Xloc)) + uX/abs(norm(uX)); Xloc=Xloc/abs(norm(Xloc))*delta + origin;
  Yloc = cross( cross(uX,uY), uY ); Yloc=Yloc/abs(norm(Yloc)) + uY/abs(norm(uY)); Yloc=Yloc/abs(norm(Yloc))*delta + origin;
  Oloc = (cross( cross(uX,uY), uY )/abs(norm(cross( cross(uX,uY), uY )))...
      + cross( uX, cross(uX,uY) )/abs(norm(cross( uX, cross(uX,uY) )))); Oloc=Oloc/abs(norm(Oloc))*delta + origin;

  text(Xloc(1), Xloc(2), 'X','color','g','Fontsize',14, 'FontWeight', 'bold');
  text(Yloc(1), Yloc(2),'Y','color','g','Fontsize',14,'HorizontalAlignment','center', 'FontWeight', 'bold');
  text(Oloc(1), Oloc(2),'O','color','g','Fontsize',14, 'FontWeight', 'bold');
end