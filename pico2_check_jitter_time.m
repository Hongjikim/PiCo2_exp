%% check jitter time in FT task

basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');

% sub_i = input('Subject number? (1,2,3):');

clear jitter 

for sub_i =1:21
    clear sub_dir
    sub_dir = filenames(fullfile(datdir, ['coco', sprintf('%.3d',sub_i), '*']), 'char');
    
    FT_files = filenames(fullfile(sub_dir, '*_FT_run*mat'));
    
    for run = 1:numel(FT_files)
        clear data;
        load(FT_files{run});
        jitter(sub_i,15*(run-1)+1:15*run) = [data.FTfunction.sampling_time(1) diff([data.FTfunction.sampling_time 14*50])];
    end
end

% size(jitter) % num(sub) * trial (60)

histogram(jitter(:), 30)

mean(jitter') % mean = 46.6667 same for every subject
mean(jitter(:)) % total mean = 46.6667
std(jitter(:)) % std = 5.9535
max(jitter(:)) % max = 60.6667
min(jitter(:)) % min = 32.6667