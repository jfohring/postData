% New file for playing with Dengue Data for Puerto Rico

% 1. Need to add coordinates from shape file for each province (admin 1)
% 2. rewrite file with updated coordinates in same format as temp data
clear
clc
close all

%% define filename, country ID, year, month
country  = 'Puerto Rico';
filename = 'CDCDengue.txt';
cID = 'PRI';

year  = 2015;
month = 1;
D     = datetime(year,month,01,'Format','yyyy.MM.dd');
d     = yyyymmdd(D);
D     = char(D,'yyyyMM');

%% Read in Dengue text file
D = readtable(filename);

% convert from table to arrays
Lat   = table2array(D(:,8));
Lon   = table2array(D(:,9));
yeardata  = table2array(D(:,6));
monthdata = table2array(D(:,7));

% get indices for correct year and month
Ind = find(yeardata == year & monthdata == month);
lat = Lat(Ind);
lon = Lon(Ind);


%% get GCM grid for specific country
Grid   = getGMCgrid(cID, 0,0.05);
newLat = Grid.Country.latcc;
newLon = Grid.Country.longcc;
[X,Y]  = meshgrid(newLon,newLat);


%%
hold on
scatter(lon,lat,'go','filled')



%% assign values to new grid (i fthe occuance is within the cell, that cell gets a value, else its zero




