% extract Veggie data from .hdf
clc
clear

%% import file from D:\Jenn\Downloads
folder = 'D:\Jenn\Downloads';
year = '2010';
month = '01';

for j = 1:12
    
    if j <=9
    month = ['0' num2str(j)];
    else month = num2str(j);
    end
    
    % correct file name
    filename = ['MOD13C2_' year month '.hdf'];

    currentfile = [folder filesep filename];
    
    % get metadata structure
    S = hdfinfo(currentfile,'eos');

    % get the name of EVI (not normalized veggie data) for the globe
    dataset = S.Grid.DataFields(2);
    datasetname = dataset.Name;

    data = hdfread(currentfile,datasetname);

    % get normalized data set as well
    dataset = S.Grid.DataFields(1);
    datasetname = dataset.Name;
    normalizedData = hdfread(currentfile,datasetname);
    
    % where to save to (currently as a mat file with the data sets and meta
    % data structure
    savefile = 'D:\Jenn\Documents\ZikaData\Data\land_cover\MOD13C2_EVI';
    save([savefile filesep year month],'S','data','normalizedData')
end