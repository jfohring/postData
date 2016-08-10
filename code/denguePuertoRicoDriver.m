% New file for playing with Dengue Data for Puerto Rico

% 1. Need to add coordinates from shape file for each province (admin 1)
% 2. rewrite file with updated coordinates in same format as temp data
clear
clc
close all
%% Read in Dengue spread sheet
filename = 'CDCDengue_PR_Mex.csv';

delimiterIn = ','; %  save files as comma separated text files ('\t') for tab separated
headerlinesIn = 1;

D = importdata(filename,delimiterIn); 

%% Read in Global Admin file for PRI


[S, A] = shaperead('PRI_adm1.shp', 'UseGeoCoords',true);