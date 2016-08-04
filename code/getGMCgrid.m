function [Grid] = getGMCgrid(country, admin)
% generate the GCM grid with top left pixel corner lat 90, long -180
% degrees with 0.05 degree pixel length (~5600m x 5600m)

% pass a string that is the country ISO code. ie 'ARG'
filename = [country '_adm' num2str(admin) '.shp'];

% learning shaperead and shapefiles (Afgahnistan)
% learning shaperead and shapefiles (Afgahnistan)
[S, ~] = shaperead(filename, 'UseGeoCoords',true);
bbox = S.BoundingBox; % [min x min y; max x max y] [min long, min lat, max long, max lat]


GGrid.World.lat = 90:-0.05:-90;
Grid.World.long = -180: 0.05: 180;

Grid.World.latcc = Grid.World.lat(1:end-1)-0.025;
Grid.World.longcc = Grid.World.long(1:end-1) + 0.025;

ind = find(bbox(1,2) >=   Grid.World.latcc  & Grid.World.latcc <= bbox(2,2));
Grid.Country.latcc = Grid.World.latcc(ind);

ind = find(bbox(1,1) >=   Grid.World.longcc  & Grid.World.longcc <= bbox(2,1));
Grid.Country.longcc = Grid.World.longcc(ind);

% Grid.Country.latcc
% Grid.Country.longcc
