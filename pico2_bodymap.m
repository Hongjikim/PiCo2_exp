%% bodymap data

datdir = '/Users/hongji/Dropbox/PiCo_fmri_task_data/data';

idx_dir = '/Users/hongji/Dropbox/sync/data/tr_idx';

load(fullfile(idx_dir, 'tr_idx.mat'));

for sub_i = 2:50
    
   tr_idx.sub_idx{sub_i} 
    
end