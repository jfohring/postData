 % driver for interpolation of temp and precipitation data to GCM (global
 % climate model) 0.05 degree (5600m x 5600m) grid. (upper left pixel
 % corner is (90,-180) decimal degrees.
 
 % you will need to have the global administrative shape file for at
 % minimum level 0 to get bounding boxes for a specific country.
 
 
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