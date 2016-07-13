% reading in tab deliminated ASCII text file
clear
clc
close all
%% import temp station locations for Argentina
filename = 'Argentina.xlsx';
delimiterIn = '\t'; % if it's the tab deliminated text file
headerlinesIn = 1;

% get a structure with headers and text
% importdata looks at file extensions and imports accordingly

T = importdata(filename,delimiterIn,headerlinesIn); 

%% extract locations of temp stations
xyz = T.data.Sheet1(:,1:3);

% for plotting only station locations,
xyz = unique(xyz,'rows');

Tz = xyz(:,1);
Tlat = xyz(:,2);
Tlong = xyz(:,3);

%% extract aegypti locations for all dates
xyz = T.data.Sheet1(:,8:10);
% remove nan's
ind = find(isnan(xyz),1,'first')-1;
Az = xyz(1:ind,1);
Alat = xyz(1:ind,2);
Along = xyz(1:ind,3);

%% extract albopitus locations for all dates
xyz = T.data.Sheet1(:,12:14);
% remove nan's
ind = find(isnan(xyz),1,'first')-1;
Bz = xyz(1:ind,1);
Blat = xyz(1:ind,2);
Blong = xyz(1:ind,3);


%% playing with maps
figure(1);clf
ax = worldmap('South America');

borders 
hold on
borders('argentina','FaceColor', [0.5 0.7 0.5])

% marker area
a = 5;
scatterm(Alat,Along,a,'filled','y')
scatterm(Blat,Blong,a,'filled','b')
scatterm(Tlat,Tlong,a,'filled','r')
% legend('','aegypti','albo','temp stations','location','southeast')


%% plot both mosi locations and station locations on map
figure(2);clf
%  worldmap 'south america'

 geoshow('landareas.shp','FaceColor',[0.5 0.7 0.5])
% geoshow('worldrivers.shp','Color', 'blue')
% geoshow('worldcities.shp','Marker','.','Color','red')

ax = gca;

ax.XLim = [-80 -50];
ax.YLim = [-60 -20];

% geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
hold on
scatter(Along,Alat,'y','filled')
scatter(Blong,Blat,'b','filled')
scatter(Tlong,Tlat,'r','filled')
legend('aegypti','albo','temp stations','location','southeast')


%% just scatter mosi locations and elevation for Argentina
figure(2);clf
scatter3(Along,Alat,Az,'y','filled'); hold all
scatter3(Blong,Blat,Bz,'b','filled'); 
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

