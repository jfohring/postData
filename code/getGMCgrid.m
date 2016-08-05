function [Grid] = getGMCgrid(country, admin)
% function [Grid] = getGMCgrid(country, admin)
% generate the GCM grid with top left pixel corner lat 90, long -180
% degrees with 0.05 degree pixel length (~5600m x 5600m)
% -----------------------------------------------------------
% ISO code for country should be a string.
% Admin level is numberica

%____________________________________________________________
% pass a string that is the country ISO code. ie 'ARG'
filename = [country '_adm' num2str(admin) '.shp'];

% learning shaperead and shapefiles (Afgahnistan)
% learning shaperead and shapefiles (Afgahnistan)
[S, ~] = shaperead(filename, 'UseGeoCoords',true);
bbox = S.BoundingBox; % [min x min y; max x max y] [min long, min lat, max long, max lat]


% extract regional mesh from big mesh
Grid.World.lat = 90:-0.05:-90;
Grid.World.long = -180: 0.05: 180;

Grid.World.latcc = Grid.World.lat(1:end-1)-0.025;
Grid.World.longcc = Grid.World.long(1:end-1) + 0.025;
ind = find(bbox(1,2) >=   Grid.World.latcc  & Grid.World.latcc <= bbox(2,2));
Grid.Country.latcc = Grid.World.latcc(ind);

ind = find(bbox(1,1) >=   Grid.World.longcc  & Grid.World.longcc <= bbox(2,1));

%% plot for testing
% rough center average of country bounding box
cent = (bbox(1,:) + bbox(2,:))/2;

figure(1),clf
geoshow(filename)
hold on
plot(bbox(1,1), bbox(1,2),'r*',bbox(2,1),bbox(1,2),'r*', 'MarkerSize',5)
plot(bbox(1,1), bbox(2,2),'r*',bbox(2,1),bbox(2,2),'r*', 'MarkerSize',5)
plot(cent(1), cent(2),'bo', 'MarkerSize',5,'LineWidth',4)
Grid.Country.longcc = Grid.World.longcc(ind);

