% extract Veggie data from .hdf
clc
clear

% import file from D:\Jenn\Downloads
folder = 'D:\Jenn\Downloads';
year = '2010';
month = '01';
filename = ['MOD13C2_' year month '.hdf'];

currentfile = [folder filesep filename];
S = hdfinfo(currentfile,'eos');


% get the name of EVI (not normalized veggie data) for the globe
dataset = S.Grid.DataFields(2);
datasetname = dataset.Name;

data = hdfread(currentfile,datasetname);

% get normalized data set as well
dataset = S.Grid.DataFields(1);
datasetname = dataset.Name;
normalizedData = hdfread(currentfile,datasetname);

figure, imagesc(data)

% where to save to
savefile = 'D:\Jenn\Documents\ZikaData\Data\land_cover\MOD13C2_EVI';
save([savefile filesep filename],'S','data','normalizedData')
