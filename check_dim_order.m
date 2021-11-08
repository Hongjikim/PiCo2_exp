
datdir =     '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
clear order
c = 0;
for sub_i= 30:39
    sub_dir = filenames(fullfile(datdir, ['*0', num2str(sub_i), '*']), 'char');
    
    survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    for run = 1:numel(survey_files)
        c= c+1;
        clear survey;
        load(survey_files{run});
        order(c,:) = survey.dat.dim_order;
    end
    
end
