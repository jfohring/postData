% scrape data from website
clear 
clc
%% 1. Open textfile to get correct url for each month, download EVI data and rename file
fid = fopen('D:\Jenn\Documents\ZikaData\Data\land_cover\MOD13C2_EVI\data_url_script_2016-08-03_151807.txt');
years = [2012, 2013,2014, 2015];
options = weboptions('Username','jfohring','Password','Forests2');
for k = 1:4
    for j = 1:12
        year = years(k);
        month = j;    
        D     = datetime(year,month,01,'Format','yyyy.MM.dd');
        D     = char(D,'yyyyMM');
        url   = fgetl(fid);

        % download hdf file to temp destop folder
        hdfFileName = ['D:\Jenn\Downloads', filesep, D,'.hdf'];
        outfilename = websave(hdfFileName,url,options);

        % get metadata structure
        S = hdfinfo(hdfFileName,'eos');

        % get the name of EVI (not normalized veggie data) for the globe
        dataset = S.Grid.DataFields(2);
        datasetname = dataset.Name;

        data = hdfread(hdfFileName,datasetname);

        % get normalized data set as well
        dataset = S.Grid.DataFields(1);
        datasetname = dataset.Name;
        normalizedData = hdfread(hdfFileName,datasetname);

        % where to save to (currently as a mat file with the data sets and meta
        % data structure
        savefile = 'D:\Jenn\Documents\ZikaData\Data\land_cover\MOD13C2_EVI';
        save([savefile filesep D],'S','data','normalizedData')

    % 
    end
end
fclose(fid);


