 % driver for interpolation of temp and precipitation data to GCM (global
 % climate model) 0.05 degree (5600m x 5600m) grid. (upper left pixel
 % corner is (90,-180) decimal degrees.
 
 % you will need to have the global administrative shape file for at
 % minimum level 0 to get bounding boxes for a specific country.
 
 
clear
clc
close all

%% import temp station locations for Argentina
country  = 'Argentina';

filename = 'Argentina_2015.csv';
year     = 2015;
month    = 1;
D        = datetime(year,month,01,'Format','yyyy.MM.dd');
d        = yyyymmdd(D);
D        = char(D,'yyyyMM');

%% extract lat, long, Temp and Precipitaion data sets
delimiterIn = ','; %  save files as comma separated text files ('\t') for tab separated
headerlinesIn = 1;

% get a structure with headers and text
% importdata looks at file extensions and imports accordingly

T = importdata(filename,delimiterIn); 

% number of stations
nstat = sum(T.data(:,4)== d);
Lat = T.data(:,2);
Lon = T.data(:,3);

% want (TPCP (total precipitation amout per month, mm)) and (MNTM (mean temp C))
colP = 38; % TPCP
colT = 50; % MNTM

Pdata = T.data(:,38);
Tdata = T.data(:,50);

% remove negative values
Pdata(find(Pdata<0)) = 0;
Tdata(find(Tdata<0)) = 0;

%% get GCM grid for specific country
Grid = getGMCgrid('ARG', 0);

%% Plot data for first 3 months of 2015;
figure(1);clf

for k = 1:3
    a = (k-1)*63 +1;
    b = k*63;

    subplot(1,2,1)
    plot(Tdata(a:b),'s-'); hold all;

    subplot(1,2,2)
    plot(Pdata(a:b),'s-'); hold all;
end
subplot(1,2,1)
title('temp data')
xlabel('station')
ylabel('ave temp /month (C)')

subplot(1,2,2)
title('precip data')
xlabel('station')
ylabel('precip/ month (mm)')




