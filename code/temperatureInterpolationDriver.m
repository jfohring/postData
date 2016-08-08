 % driver for interpolation of temp and precipitation data to GCM (global
 % climate model) 0.05 degree (5600m x 5600m) grid. (upper left pixel
 % corner is (90,-180) decimal degrees.
 
 % you will need to have the global administrative shape file for at
 % minimum level 0 to get bounding boxes for a specific country.
 
clear
clc
close all

%% import temp station locations for a specific country. 
% Need also the coundtry ID see http://www.gadm.org/, https://en.wikipedia.org/wiki/GADM
% for more information on Global administrative areas
 
% this is just for plotting country borders using the borders function
country  = 'Argentina';
 country  = 'Bolivia';
% country  = 'Brazil';

% ******Make sure the temperature .csv data file is sorted by DATE and that any 'unknown' values
% in the spreadsheet are replaced with NaN. If not, the importdata function
% will freak out. 

 filename = 'Argentina_2015.csv';
 filename = 'Bolivia_2015.csv';
%  filename = 'Brazil_2015.csv';

% ADM country ID (you can get this just by looking in the ADM country
% folder (it's just so the getGCM grid function opens the correct file

cID = 'ARG';
 cID = 'BOL';
% cID = 'BRA';

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
%   note: import data returns a structure with both the numeric data and the
%   header text data. Since the first 2 columns of the csv files are text,
%   the headers are shifted 2 columns to the right. In other words elevations
%   are in colunm 1 of T.data, not column 3 as the csv file would suggest. 

T = importdata(filename,delimiterIn); 

% number of stations
nstat = sum(T.data(:,4)== d);
Lat   = T.data(:,2);
Lon   = T.data(:,3);
dates = T.data(:,4);

% want (TPCP (total precipitation amout per month, mm)) and (MNTM (mean temp C))
colP = 38; % TPCP
colT = 50; % MNTM

Pdata = T.data(:,colP);
Tdata = T.data(:,colT);

% remove negative values (this potentially could be done in excel too)
Pdata(find(Pdata<0)) = NaN;
Tdata(find(Tdata<0)) = NaN;

%% look at data set for each year
% for k = 1:12
%     D = datetime(year,k,01,'Format','yyyy.MM.dd');
%     d  = yyyymmdd(D);
%     yearInd = find(T.data(:,4) == d);
%     
%     figure(2), hold all
%     plot(Pdata(yearInd),'s-')
%     title(['Precip data (mm). n stations = ',num2str(length(yearInd))])
%     figure(3), hold all
%     plot(Tdata(yearInd),'o-')
%     title('temp data (C)')
% end

%% get GCM grid for specific country
Grid = getGMCgrid(cID, 0);
newLat = Grid.Country.latcc;
newLon = Grid.Country.longcc;
[X,Y]  = meshgrid(newLon,newLat);

%% interpolate data to argentina grid for 12 months
PDATA = [];
TDATA = [];
DATES = [];

for k = 1:12
    D = datetime(year,k,01,'Format','yyyy.MM.dd');
    d  = yyyymmdd(D);
    yearInd = find(T.data(:,4) == d);
    
    % get grid and values for current month
    oldLat = Lat(yearInd);
    oldLon = Lon(yearInd);

    % get data values
    p = Pdata(yearInd);
    t = Tdata(yearInd);

    figure(1),
    scatter(oldLon,oldLat,20,t,'s', 'filled')
    title('temp data');
    
    % Interpolate and extrapolate data to GCM grid. Currently using discontinuous
    % nearest neighbour interpolation and extrapolation
    % NOTE: linear and natural interpolation introduces wild values.
    % Nearest keeps the range within the original data value range. Need to
    % smoothe when stitching all country tiles together later. (Domain
    % decoposition problem essentially)
    
    
    Fp = scatteredInterpolant(oldLon,oldLat,p,'nearest','nearest');
    pGCM = Fp(X,Y);
    Ft = scatteredInterpolant(oldLon,oldLat,t,'nearest','nearest');
    tGCM = Ft(X,Y);
    
    % store in big vector for each month
    PDATA = [PDATA; pGCM(:)];
    TDATA = [TDATA; tGCM(:)];
    DATES = [DATES; d*ones(length(pGCM(:)),1)];
end

%% Make table for csv file
Long = X(:)*ones(1,12); Long = Long(:);
Lat = Y(:)*ones(1,12);  Lat  = Lat(:);

Table = table(Lat,Long,DATES,PDATA,TDATA);

% get the directory to ZikaData folder on your computer and generate path
% to folder for saving
dir = fullfile(pwd);
pathname = [dir filesep  'Data\combined_data\South_America'];

% add the file name
csvfile = fullfile(pathname, ['GCM_' country '_' num2str(year) '.csv']);

writetable(Table,csvfile);


%% Plots
figure(4),clf
subplot(1,2,1)
imagesc(newLon, newLat,tGCM)
axis equal
set(gca,'YDir','normal')
bb = Grid.BoundingBox;
axis([bb(1,1) bb(2,1) bb(1,2) bb(2,2)])


hold on
scatter(oldLon,oldLat,20,t,'s','filled')
scatter(oldLon,oldLat,21,'ks')
title('GCM temp data');
    
[la,lo] = borders(country);
scatter(lo,la,2,'ko','filled')

%
subplot(1,2,2)
imagesc(newLon, newLat,pGCM)
axis equal
set(gca,'YDir','normal')
bb = Grid.BoundingBox;
axis([bb(1,1) bb(2,1) bb(1,2) bb(2,2)])


hold on
scatter(oldLon,oldLat,20,p,'s','filled')
scatter(oldLon,oldLat,21,'ks')
title('GCM precipitation data');
    
[la,lo] = borders(country);
scatter(lo,la,2,'ko','filled')
%