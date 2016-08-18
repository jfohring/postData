% New file for playing with Dengue Data for Puerto Rico and adding
% occurances to the new GCM grid

clear
clc
close all

%% define filename, country ID, year, month
country  = 'Puerto Rico';
filename = 'CDCDengue.txt';
cID = 'PRI';

%% get cell centered GCM grid for specific country
m = 0.05;
Grid   = getGCMgrid(cID, 0,m);
newLat = Grid.Country.latcc;
newLon = Grid.Country.longcc;
[X,Y]  = meshgrid(newLon,newLat);
X = X(:);
Y = Y(:);
val = zeros(length(X),1);

%% loop over each month

% Read in Dengue text file
D = readtable(filename);

% convert from table to arrays
Lat = table2array(D(:,8));
Lon = table2array(D(:,9));
yeardata  = table2array(D(:,6));
monthdata = table2array(D(:,7));

year  = 2015;
nmonths = 12;

Occur = [];

for ii = 1:nmonths
    
    month = ii;
    D     = datetime(year,month,01,'Format','yyyy.MM.dd');
    d     = yyyymmdd(D);
    Date   = char(D,'yyyyMM');

    % get indices for correct year and month
    Ind = find(yeardata == year & monthdata == month);
    lat = Lat(Ind);
    lon = Lon(Ind);

    nCases = length(Ind); % total case per year

    % plot locations on map from getGCMgrid
    hold on
    scatter(lon,lat,'go','filled')
    title(['Dengue case locations. Total cases: ' num2str(nCases)])

    % assign values to new grid (if the occuance is within the cell, that cell gets a value, else its zero
     xy = [lon,lat];                            % lat and long of regions
     [C, ia, ic] = unique(xy,'rows', 'stable'); % remove repeats
     nDengue =  [ia(2:end);length(lat)+1]-ia;   % number of dengue cases per region
 
     % need to deterine what GCM grid cell xy belongs to and add correct number
     % of Dengue instances then write to corrent file
     
     % get regional coordinates for areas with Dengue
     x = C(:,1);
     y = C(:,2);

     % loop over number of regions and over new grid. Identify cells where
     % there is an occuance and store the number of occurences for that grid
     for k = 1:length(x);     
        for j = 1:length(X)        
             if (x(k)>= X(j)-m/2) && (x(k) <= X(j) + m/2) &&...
                     (y(k)>= Y(j)-m/2) && (y(k) <= Y(j) + m/2)
                val(j) = nDengue(k);
             end         
        end    
     end
     Occur = [Occur;val];
     
end
%% open Puerto Rico file and add a colunm with the dengue occurences
% File paths and names for saving. For Puerto Rico, saving to combined_data\Central_Americal
% get the directory to ZikaData folder on your computer and generate path
% to folder for saving
dir = fullfile(pwd);
pathname = [dir filesep  'Data\combined_data\Central_America'];
safefilecountry = 'Puerto_Rico'; % if you want it to be different the 'country' variable above

% add the file name
csvfile = fullfile(pathname, ['GCM_' safefilecountry '_' num2str(year)  '.csv']);
 
% read the existing table
OldT = readtable(csvfile);
% add the new data
newT = [OldT,array2table(Occur)];
% change the variable name


savefile = fullfile(pathname, ['GCM_' safefilecountry '_' num2str(year) '_Dengue'  '.csv']);
newT.Properties.VariableNames{'Occur'} = 'DengueCases';

writetable(newT, savefile);





