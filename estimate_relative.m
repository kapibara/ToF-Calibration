function [dR,dt]=estimate_relative(calib)

    [dR,dt] = estimate_plane_to_plane(calib.Rext,calib.text,calib.cRext,calib.ctext);

end