%% check nan_idx

basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');

for sub_i = 1:70% 201:228
    
    if sub_i < 10
        sub_dir = filenames(fullfile(basedir, 'data', ['coco00', num2str(sub_i), '*']), 'char');
        [~, sid] = fileparts(sub_dir);
    elseif sub_i > 199 % session2
        sub_dir = filenames(fullfile(basedir, 'data_session2', ['coco', num2str(sub_i), '*']), 'char');
        [~, sid] = fileparts(sub_dir);
    else
        sub_dir = filenames(fullfile(basedir, 'data', ['coco0', num2str(sub_i), '*']), 'char');
        [~, sid] = fileparts(sub_dir);
    end
    
    target_fname = filenames(fullfile(sub_dir, '*word_nan_idx*mat'), 'char');
    load(target_fname)
    
    nan_idx_all{sub_i} = nan_idx;
end

%%
for sub_i = 1:70% 201:228
    % 1: no idea (¾øÀ½)
    res_all.none(sub_i,:) = sum(nan_idx_all{sub_i} == 1);
%     res_all.none(sub_i-200,:) = sum(nan_idx_all{sub_i} == 1);
    % 2: X (couldn't get the response)
    res_all.X(sub_i,:) = sum(nan_idx_all{sub_i} == 2);
%     res_all.X(sub_i-200,:) = sum(nan_idx_all{sub_i} == 2);
end

%%
close all;
bin = 30;

for run = 1:4
    subplot(2,5,run)
    histogram(res_all.none(:,run), bin);
    
    subplot(2,5,run+5)
    histogram(res_all.X(:,run), bin);
end

subplot(2,5,5)
histogram(sum(res_all.none,2), bin);
subplot(2,5,10)
histogram(sum(res_all.X,2), bin);

%% 
close all;
bin = 30;

subplot(2,1,1)
histogram(sum(res_all.none,2), bin);
subplot(2,1,2)
histogram(sum(res_all.X,2), bin);
