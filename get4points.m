function [x,y,b] = get4points(I,detector,wintx,winty)
    x = [];
    y = [];
    figure(1); hold on;
    for count = 1:4,
        [xi,yi,b] = ginput(1);
        if(b==27)
          %Esc = skip image
          x = [];
          y = [];
          return;
        end
        
        [xxi] = detector([xi;yi],I);%,winty,wintx);
        xi = xxi(1);
        yi = xxi(2);
        figure(1);
        plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);
        plot(xi + [wintx+.5 -(wintx+.5) -(wintx+.5) wintx+.5 wintx+.5],yi + [winty+.5 winty+.5 -(winty+.5) -(winty+.5)  winty+.5],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
        x = [x;xi];
        y = [y;yi];
        plot(x,y,'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
        drawnow;
    end;
    plot([x(1) x(end)],[y(1) y(end)],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
end