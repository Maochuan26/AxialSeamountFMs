function colmap = red2blue (cmin, cmax, cint)

% usage: colmap = red2blue (cmin, cmax, cint)
% where
%
%  INPUTS:
%		cmin, cmax = minimum and maximum values of the colo scale.
%		cint = color interval
%


col_palette = [cmin:cint:cmax];
ncol=length(col_palette)-1;

d1 = 1/(ncol/2-1);
d2 = (1-d1)/(ncol/2-1);

scale=[0:d2:1-d1];
colmap_blue = [flipud(scale')*ones(1,2), ones(length(scale),1) ];
colmap_red = flipud(fliplr(colmap_blue));

colmap = [colmap_red; colmap_blue];

return
