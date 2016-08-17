% New file for playing with Dengue Data for Puerto Rico and adding
% occurances to the new GCM grid

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

nCases = length(Ind); % total case per year

%% get GCM grid for specific country
Grid   = getGCMgrid(cID, 0,0.05);
newLat = Grid.Country.latcc;
newLon = Grid.Country.longcc;

%% pLot locations on map from getGCMgrid
hold on
scatter(lon,lat,'go','filled')
title(['Dengue case locations. Total cases: ' num2str(nCases)])

%% assign values to new grid (if the occuance is within the cell, that cell gets a value, else its zero
 xy = [lon,lat];                            % lat and long of regions
 [C, ia, ic] = unique(xy,'rows', 'stable'); % remove repeats
 nDengue =  [ia(2:end);length(lat)+1]-ia;   % number of dengue cases per region
 
 % need to deterine what GCM grid cell xy belongs to and add correct number
 % of Dengue instances then write to corrent file
 
latE = Grid.Country.lat;  % nodal grid
lonE = Grid.Country.long; % nodal grid

 




