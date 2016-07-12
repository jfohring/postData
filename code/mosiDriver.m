% reading in tab deliminated ASCII text file
clear
clc
close all
%% import temp station locations for Argentina
filename = [ 'combined_data' filesep 'SouthAmerica.xlsx'];
delimiterIn = '\t'; % if it's the tab deliminated text file
headerlinesIn = 1;

% get a structure with headers and text
% importdata looks at file extensions and imports accordingly

T = importdata(filename,delimiterIn,headerlinesIn); 

%% extract locations and elevation of temp stations

xyzdata = T.data;
data = data(:,1:3);
data = unique(data,'rows');

Tz = data(:,1);
Tlat = data(:,2);
Tlong = data(:,3);

%% import mosi data locations and elevation
filename = 'aegypti_CSA_elevation.xlsx';
delimiterIn = '\t'; % if it's the tab deliminated text file
headerlinesIn = 1;
sheet = 1;

% get a structure with headers and text
% importdata looks at file extensions and imports accordingly
A = importdata(filename,delimiterIn,headerlinesIn); 

%% indexes to Argentina
countries = A.textdata.aegypti_CSA_elevation(2:end,1);
% get the indexes into the data file for argentina
ind = find(not(cellfun('isempty', strfind(countries,'Argentina'))));

% extract mosi data for all dates, for Argentina
ArgData = A.data.aegypti_CSA_elevation(ind,:);

% get lat, lon, elevation for all years
lat  = ArgData(:,2);
long = ArgData(:,3);
Z    = ArgData(:,4);
%% 
figure(9); clf
ax = worldmap('Argentina');
setm(ax,'MapProjection','pcarree','MapLatLimit',[-70 80])








%% plot both mosi locations and station locations on map
figure(1);clf
%  worldmap 'south america'

geoshow('landareas.shp','FaceColor',[0.5 0.7 0.5])
% geoshow('worldrivers.shp','Color', 'blue')
% geoshow('worldcities.shp','Marker','.','Color','red')

ax = gca;

ax.XLim = [-80 -50];
ax.YLim = [-60 -20];

% geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
hold on
scatter(lat,long,'y','filled')
scatter(Tlong,Tlat,'r','filled')
legend('mosquitos','temp stations','location','southeast')

%% playing with topo data

% load topo topo topmap1



%% just scatter mosi locations and elevation for Argentina
figure(2);clf
scatter3(lat,long,Z,'y','filled'); hold all
scatter3(Tlong,Tlat,Tz,'r','filled')
% legend('mosquitos','temp stations')
ax = gca;

ax.XLim = [-100 -10];
ax.YLim = [-70 20];
% %%
% figure(3);clf
% worldmap('canada')
% h = worldmap(map, refvec);
% set(h, 'Visible', 'off')
% 
% geoshow(h, map, refvec, 'DisplayType', 'texturemap')
% demcmap(map)

