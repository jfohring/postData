% startup file to generate matlab paths for running code

clc
fprintf('Setting paths for Zika Project \n\n')

subdirs = {'populationData','pop_econ_data','noaa_temp_precip_elevation','mosquitos','diseaseOutbreaks',...
           genpath('noaa_temp_precip_elevation'),genpath('pop_econ_data')} ;
          
dir = fullfile(pwd);
       addpath(dir);  
       
for i = 1:size(subdirs,2),
    
   dir = fullfile(pwd,subdirs{i});
   fprintf('adding %s \n',dir);

   addpath(dir);
end
fprintf('\n You''re all set now! Have Fun!\n')