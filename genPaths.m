% startup file to generate matlab paths for running code

clc
fprintf('Setting paths for Zika Project \n\n')

subdirs = { genpath('Data'),genpath('code')} ;
          
dir = fullfile(pwd);
       addpath(dir);  
       
for i = 1:size(subdirs,2),
    
   dir = fullfile(pwd,subdirs{i});
   fprintf('adding %s \n',dir);

   addpath(dir);
end
fprintf('\n You''re all set now! Have Fun!\n')