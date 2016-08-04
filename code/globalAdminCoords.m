% write a script to extract admin level coordinates for specified country
% form large database. (ADMIN level 0-2) Need polygon centre coordinates,
% and to plot polygons (Downloaded from http://www.gadm.org/version2)
% J.Fohring Aug 2016. 


% learning shaperead and shapefiles (Afgahnistan)
[S, A] = shaperead('ARG_adm1.shp', 'UseGeoCoords',true);

% just plot all the admin level 1 provincial boundaries
figure(1)
geoshow('ARG_adm1.shp')
