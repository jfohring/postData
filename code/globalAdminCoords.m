% write a script to extract admin level coordinates for specified country
% form large database. (ADMIN level 0-2) Need polygon centre coordinates,
% and to plot polygons (Downloaded from http://www.gadm.org/version2)
% J.Fohring Aug 2016. 
clc
country = 'ARG';
admin = 0; 
filename = [country '_adm' num2str(admin) '.shp'];

% learning shaperead and shapefiles (Afgahnistan)
[S, A] = shaperead(filename, 'UseGeoCoords',true);
bbox = S.BoundingBox; % [min x min y; max x max y] [min long, min lat, max long, max lat]


%% extract regional mesh from big mesh
Grid.World.lat = 90:-0.05:-90;
Grid.World.long = -180: 0.05: 180;

Grid.World.latcc = Grid.World.lat(1:end-1)-0.025;
Grid.World.longcc = Grid.World.long(1:end-1) + 0.025;
ind = find(bbox(1,2) >=   Grid.World.latcc  & Grid.World.latcc <= bbox(2,2));
Grid.Country.latcc = Grid.World.latcc(ind);

ind = find(bbox(1,1) >=   Grid.World.longcc  & Grid.World.longcc <= bbox(2,1));
Grid.Country.longcc = Grid.World.longcc(ind);

% rough center average of country bounding box
cent = (bbox(1,:) + bbox(2,:))/2;


%% just plot all the admin level 1 provincial boundaries
figure(1),clf
geoshow('ARG_adm0.shp')
hold on
plot(bbox(1,1), bbox(1,2),'r*',bbox(2,1),bbox(1,2),'r*', 'MarkerSize',5)
plot(bbox(1,1), bbox(2,2),'r*',bbox(2,1),bbox(2,2),'r*', 'MarkerSize',5)
plot(cent(1), cent(2),'bo', 'MarkerSize',5,'LineWidth',4)
