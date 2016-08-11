% New file for playing with Dengue Data for Puerto Rico

% 1. Need to add coordinates from shape file for each province (admin 1)
% 2. rewrite file with updated coordinates in same format as temp data
clear
clc
close all
%% Read in Dengue spread sheet
filename = 'CDCDengue.txt';
D = readtable(filename);


lat = table2array(D(:,8));
Lon = table2array(D(:,9));

year = table2array(D(:,6));
month = table2array(D(:,7));






