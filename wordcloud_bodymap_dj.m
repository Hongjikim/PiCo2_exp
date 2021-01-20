%% Load Data
datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
datadir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:end-6); % select manually
subnames(7:end-1) = subnames(8:end); % 7 out
subnames(12:end-1) = subnames(13:end); % 13 out
subnames(13:end-1) = subnames(14:end); % 15 out
subnames(20:end-1) = subnames(21:end);% 23 out
subnames = subnames(1:end-4); % 1: end-# of extracted sub

j=0;

bodymap = imread(fullfile(datadir, 'bodymap_screenshot.png'));    % screenshot of the real survey screen
bodymap = bodymap(:,:,1);
bodymap([1:262 907:1080], :) = [];
bodymap(:, [1:1534 1751:1920]) = []; % bodymap = 644 X 216
body_white_binary = imresize(bodymap==255, 900/1080, 'nearest');
bodymap = imresize(bodymap, 900/1080, 'nearest');

screen_sz = [900 1600];
cut_edge = [262/1080 907/1080 1534/1920 1751/1920] .* reshape(repmat(screen_sz,2,1),1,4);
cut_edge = round(cut_edge);
ratings = cell(1, numel(subnames));
W = cell(1, numel(subnames));

for subject_i = 1:numel(subnames)
    sub_dir = fullfile(datdir, subnames{subject_i});
    
    fprintf('\n>>> working on sub_%02d >>>', subject_i)
    
    j=j+1;
    
    % load survey data of one subject
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    load(post_type3{1});
    original = survey.dat;
    
    % ratings
    for run_i = 1:4
        for dim_i = 1:5
            for word_i = 1:15
                ratings{1,subject_i}{word_i+15*(run_i-1)+1,dim_i} = original{run_i,word_i}{1,dim_i}.rating;
            end
        end
    end
    
    
    % words
    original_word = survey.words;
    original_word = reshape(original_word', 60, 1);
    dims = survey.dat_descript;
    
    for trial_i = 1:60
        W{1, subject_i}{trial_i,1} = original_word{trial_i,1};
    end
    
    ratings_descript = {'valence', 'self', 'time', 'vividness', 'safety-threat'};
    for d = 1:5
        ratings{1,subject_i}{1,d} = ratings_descript{d};
    end
    
    % bodymap
    b{j,1} = num2str(extractAfter(sub_dir, "/data/")); % the first column of B is subnum
    b{j,2} = cell(60,2);  % the first column of B{j,2} is for red.
    % the second column of B{j,2} is for blue.
    b{j,3} = cell(60,2);
    for run_i = 1:4
        for word_i = 1:15
            b{j,2}{word_i+15*(run_i-1),1} = original{run_i,word_i}{1,6}.rating_red;
            b{j,2}{word_i+15*(run_i-1),2} = original{run_i,word_i}{1,6}.rating_blue;
        end
    end
    
    % Subtract empty area, x-1534, y-262
    for i=1:60
        if ~isempty(b{j,2}{i,1})    % rating red
            b{j,2}{i,1}(:,3) = b{j,2}{i,1}(:,1);
            b{j,2}{i,1}(:,1) = [];
            
            b{j,2}{i,1}(:,1) = b{j,2}{i,1}(:,1)-cut_edge(1);    % y-axis, length
            b{j,2}{i,1}(:,2) = b{j,2}{i,1}(:,2)-cut_edge(3);   % x-axis, width
        end
        
        if ~isempty(b{j,2}{i,2})    % rating blue
            b{j,2}{i,2}(:,3) = b{j,2}{i,2}(:,1);
            b{j,2}{i,2}(:,1) = [];
            
            b{j,2}{i,2}(:,1) = b{j,2}{i,2}(:,1)-cut_edge(1);    % y-axis
            b{j,2}{i,2}(:,2) = b{j,2}{i,2}(:,2)-cut_edge(3);   % x-axis
        end
    end
    
    % round up to integer
    for i =1:60
        b{j,2}{i,1} = round(b{j,2}{i,1});
        b{j,2}{i,2} = round(b{j,2}{i,2});
    end
    
    % B{j,3} = 42 x 2 cell
    for i = 1:60
        b{j,3}{i,1} = zeros(size(body_white_binary));     % 644 x 216
        b{j,3}{i,2} = zeros(size(body_white_binary));     % 644 x 216
    end
    
    for i = 1:60
        if ~isempty(b{j,2}{i,1})    % rating red
            for m = 1:size(b{j,2}{i,1},1)
                if b{j,2}{i,1}(m,1)>0 && b{j,2}{i,1}(m,2)>0 && b{j,2}{i,1}(m,1)<size(body_white_binary,1) && b{j,2}{i,1}(m,2)<size(body_white_binary,2)
                    b{j,3}{i,1}(b{j,2}{i,1}(m,1), b{j,2}{i,1}(m,2)) = 1;
                end
            end
        end
        
        if ~isempty(b{j,2}{i,2})    % rating blue
            for m = 1:size(b{j,2}{i,2},1)
                if b{j,2}{i,2}(m,1)>0 && b{j,2}{i,2}(m,2)>0 && b{j,2}{i,2}(m,1)<size(body_white_binary,1) && b{j,2}{i,2}(m,2)<size(body_white_binary,2)
                    b{j,3}{i,2}(b{j,2}{i,2}(m,1), b{j,2}{i,2}(m,2)) = 1;
                end
            end
        end
    end
end



B.data = b;
savename = fullfile(datdir, 'pico2_body_dongju.mat');
save(savename, 'B', '-v7.3');

words = W;
subject_id = b(:,1);
body_dat = b(:,3);

savename = fullfile(datdir, 'pico2_dat_dongju.mat');
save(savename, 'subject_id', 'body_dat','ratings', 'words', '-v7.3');
save(savename, 'body_white_binary', '-append');
savedir =  '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_cloud';


%% type3 Valence max/min words

val_word = cell(60, 14);
val_r = [];
val_max = [];
val_min = [];
A = [1:2:subject_i*2-1];
B = [2:2:subject_i*2];
string_valmax = [];
string_valmin = [];
max_i = 0;
min_i =0;

for subject_i2 = 1:subject_i
    max_num = 0;
    min_num = 0;
    val_r = [ratings{1,subject_i2}{2:end,1}]';
    for trial_i3 = 1:numel(val_r)
        val_word{trial_i3, subject_i2} = words{1, subject_i2}{trial_i3,1};
        if ratings{1,subject_i2}{trial_i3+1,1} >= prctile(val_r, 80)
            max_num = max_num+1;
            max_i = max_i +1;
            val_max{max_num, A(subject_i2)} = val_word{trial_i3, subject_i2};
            val_max{max_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,1};
            string_valmax{max_i,1} = val_word{trial_i3, subject_i2};
        elseif ratings{1,subject_i2}{trial_i3+1,1} <= prctile(val_r, 20)
            min_num = min_num+1;
            min_i = min_i +1;
            val_min{min_num, A(subject_i2)} = val_word{trial_i3, subject_i2};
            val_min{min_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,1};
            string_valmin{min_i,1} = val_word{trial_i3, subject_i2};
        end
    end
end


% % max word cloud
% string_valmax = cellstr(string_valmax);
% histogram(string_valmax);
% saveas(gcf,fullfile(savedir,'hist_ValenceMax.png'))

string_valmax = categorical(string_valmax);
color = [252,141,89]./255;
figure
wordcloud(string_valmax, 'HighlightColor', color);
title("Valence max Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_ValenceMax.png'))

% min words
% string_valmin = cellstr(string_valmin);
% histrogram(string_valmin);
% saveas(gcf,fullfile(savedir,'hist_ValenceMin.png'))

string_valmin = categorical(string_valmin);
color = [252,141,89]./255;
figure
wordcloud(string_valmin, 'HighlightColor', color);
title("Valence min Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_ValenceMin.png'))


%% type3 safety&threat max/min words

sth_word = cell(60, 14);
sth_r = [];
sth_max = [];
sth_min = [];
A = [1:2:subject_i*2-1];
B = [2:2:subject_i*2];
string_sthmax = [];
string_sthmin = [];
max_i = 0;
min_i =0;

for subject_i2 = 1:subject_i
    max_num = 0;
    min_num = 0;
    sth_r = [ratings{1,subject_i2}{2:end,5}]';
    for trial_i3 = 1:numel(sth_r)
        sth_word{trial_i3, subject_i2} = words{1, subject_i2}{trial_i3,1};
        if ratings{1,subject_i2}{trial_i3+1,5} >= prctile(sth_r, 80)
            max_num = max_num+1;
            max_i = max_i +1;
            sth_max{max_num, A(subject_i2)} = sth_word{trial_i3, subject_i2};
            sth_max{max_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,5};
            string_sthmax{max_i,1} = sth_word{trial_i3, subject_i2};
        elseif ratings{1,subject_i2}{trial_i3+1,5} <= prctile(sth_r, 20)
            min_num = min_num+1;
            min_i = min_i +1;
            sth_min{min_num, A(subject_i2)} = sth_word{trial_i3, subject_i2};
            sth_min{min_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,5};
            string_sthmin{min_i,1} = sth_word{trial_i3, subject_i2};
        end
    end
end


%bar plot(sth max)
% figure
% histogram(char(string_sthmax), 'FaceColor', [153,142,195]./225);
% % y axis 3-7.4, fontsize 20
% saveas(gcf,fullfile(savedir,'hist_sthmax.png'))

% word cloud
string_sthmax = categorical(string_sthmax);
color = [252,141,89]./255;
figure
wordcloud(string_sthmax, 'HighlightColor', color);
title("safe/threat max Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_SthMax.png'))

% min words
% string_sthmin = cellstr(string_sthmin);
% histrogram(string_sthmin);
% saveas(gcf,fullfile(savedir,'hist_sthmin.png'))

string_sthmin = categorical(string_sthmin);
color = [252,141,89]./255;
figure
wordcloud(string_sthmin, 'HighlightColor', color);
title("safe/threat min Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_SthMin.png'))


%% type3 self max/min word

% self max
 
sf_word = cell(60, 14);
sf_r = [];
sf_max = [];
sf_min = [];
A = [1:2:subject_i*2-1];
B = [2:2:subject_i*2];
string_sfmax = [];
string_sfmin = [];
max_i = 0;
min_i =0;

for subject_i2 = 1:subject_i
    max_num = 0;
    min_num = 0;
    sf_r = [ratings{1,subject_i2}{2:end,2}]';
    for trial_i3 = 1:numel(sth_r)
        sf_word{trial_i3, subject_i2} = words{1, subject_i2}{trial_i3,1};
        if ratings{1,subject_i2}{trial_i3+1,5} >= prctile(sf_r,80)
            max_num = max_num+1;
            max_i = max_i +1;
            sf_max{max_num, A(subject_i2)} = sf_word{trial_i3, subject_i2};
            sf_max{max_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,2};
            string_sfmax{max_i,1} = sf_word{trial_i3, subject_i2};
        elseif ratings{1,subject_i2}{trial_i3+1,2} <= prctile(sf_r, 20)
            min_num = min_num+1;
            min_i = min_i +1;
            sf_min{min_num, A(subject_i2)} = sf_word{trial_i3, subject_i2};
            sf_min{min_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,2};
            string_sfmin{min_i,1} = sf_word{trial_i3, subject_i2};
        end
    end
end



%bar plot(sf max)
% figure
% histogram(categorical(string_sfmax), 'FaceColor', [153,142,195]./225);
% % y axis 3-7.4, fontsize 20
% saveas(gcf,fullfile(savedir,'hist_sfmax.png'))

% histogram(string_valmax)


% word cloud
string_sfmax = categorical(string_sfmax);
color = [252,141,89]./255;
figure
wordcloud(string_sfmax, 'HighlightColor', color);
title("self max Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_SelfMax.png'))

% min words
% string_sfmin = cellstr(string_sfmin);
% string_sfmin = categorical(string_sfmin);
%histrogram(string_valmin);

string_sfmin = categorical(string_sfmin);
color = [252,141,89]./255;
figure
wordcloud(string_sfmin, 'HighlightColor', color);
title("self min Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_SelfMin.png'))


%% type3 vivid

vv_word = cell(60, 14);
vv_r = [];
vv_max = [];
vv_min = [];
A = [1:2:subject_i*2-1];
B = [2:2:subject_i*2];
string_vvmax = [];
string_vvmin = [];
max_i = 0;
min_i =0;

for subject_i2 = 1:subject_i
    max_num = 0;
    min_num = 0;
    vv_r = [ratings{1,subject_i2}{2:end,4}]';
    for trial_i3 = 1:numel(vv_r)
        vv_word{trial_i3, subject_i2} = words{1, subject_i2}{trial_i3,1};
        if ratings{1,subject_i2}{trial_i3+1,4} >= prctile(vv_r,80)
            max_num = max_num+1;
            max_i = max_i +1;
            vv_max{max_num, A(subject_i2)} = vv_word{trial_i3, subject_i2};
            vv_max{max_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,4};
            string_vvmax{max_i,1} = vv_word{trial_i3, subject_i2};
        elseif ratings{1,subject_i2}{trial_i3+1,4} <= prctile(vv_r, 20)
            min_num = min_num+1;
            min_i = min_i +1;
            vv_min{min_num, A(subject_i2)} = vv_word{trial_i3, subject_i2};
            vv_min{min_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,4};
            string_vvmin{min_i,1} = vv_word{trial_i3, subject_i2};
        end
    end
end


% word cloud
string_vvmax = categorical(string_vvmax);
color = [252,141,89]./255;
figure
wordcloud(string_vvmax, 'HighlightColor', color);
title("vivid max Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_VividMax.png'))

% min words
% string_sfmin = cellstr(string_sfmin);
% string_sfmin = categorical(string_sfmin);
%histrogram(string_valmin);

string_vvmin = categorical(string_vvmin);
color = [252,141,89]./255;
figure
wordcloud(string_vvmin, 'HighlightColor', color);
title("vivid min Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_VividMin.png'))





%% type3 time


tm_word = cell(60, 14);
tm_r = [];
tm_max = [];
tm_min = [];
A = [1:2:subject_i*2-1];
B = [2:2:subject_i*2];
string_tmmax = [];
string_tmmin = [];
max_i = 0;
min_i =0;

for subject_i2 = 1:subject_i
    max_num = 0;
    min_num = 0;
    tm_r = [ratings{1,subject_i2}{2:end,3}]';
    for trial_i3 = 1:numel(tm_r)
        tm_word{trial_i3, subject_i2} = words{1, subject_i2}{trial_i3,1};
        if ratings{1,subject_i2}{trial_i3+1,3} >= prctile(tm_r,80)
            max_num = max_num+1;
            max_i = max_i +1;
            tm_max{max_num, A(subject_i2)} = tm_word{trial_i3, subject_i2};
            tm_max{max_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,3};
            string_tmmax{max_i,1} = tm_word{trial_i3, subject_i2};
        elseif ratings{1,subject_i2}{trial_i3+1,3} <= prctile(tm_r, 20)
            min_num = min_num+1;
            min_i = min_i +1;
            tm_min{min_num, A(subject_i2)} = tm_word{trial_i3, subject_i2};
            tm_min{min_num, B(subject_i2)} = ratings{1,subject_i2}{trial_i3,3};
            string_tmmin{min_i,1} = tm_word{trial_i3, subject_i2};
        end
    end
end




% word cloud
string_tmmax = categorical(string_tmmax);
color = [252,141,89]./255;
figure
wordcloud(string_tmmax, 'HighlightColor', color);
title("time max Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_TimeMax.png'))

% min words
string_tmmin = categorical(string_tmmin);
color = [252,141,89]./255;
figure
wordcloud(string_tmmin, 'HighlightColor', color);
title("time min Word Cloud")
saveas(gcf,fullfile(savedir,'type3_WordsCloud_TimeMin.png'))



%% word clouds for type2 (19dim)

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
datadir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:end-6); % select manually
subnames(7:end-1) = subnames(8:end); % 7 out
subnames(12:end-1) = subnames(13:end); % 13 out
subnames(13:end-1) = subnames(14:end); % 15 out
subnames(20:end-1) = subnames(21:end);% 23 out
subnames = subnames(1:end-4); % 1: end-# of extracted sub

count = 0;
for sub_num = 1:numel(subnames)
    clear sub_dir; sub_dir = filenames(fullfile(datdir, subnames{sub_num}), 'char');
    clear survey_files; survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    
    for run = 1:numel(survey_files)
        count = count+1;
        clear survey; load(survey_files{run});
        for dims_i = 1:numel(survey.dat.response)
            dat_all{dims_i}(count,:) = survey.dat.response{dims_i}(run,:);
        end
    end
end

clear words;

for sub_num = 1:numel(subnames)
    clear sub_dir; sub_dir = filenames(fullfile(datdir, subnames{sub_num}), 'char');
    clear survey_files; survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    load(survey_files{1})
    for run = 1:numel(survey_files)
        for dims_i = 1:numel(survey.dat.response)
            dat_sixty{dims_i}(sub_num, 1+15*(run-1):15+15*(run-1)) = dat_all{dim_i}(run + 4*(sub_num-1), :);
            words(:, sub_num) = reshape(survey.dat.whole_words, 1, 60);
        end
    end
end




% dat_all(1, dim)(4*sub,15words)
% r -> dat_all(1, dim)([1:4]*sub)

%% type2 pos // neg

pos_r = [];
neg_r = [];
pos_max = [];
neg_max = [];
A = [1:2:sub_num*2-1];
B = [2:2:sub_num*2];
string_posmax = [];
string_negmax = [];
max_i = 0;
min_i =0;


for subject_i2 = 1:sub_num
    pos_r(subject_i2, :) = reshape([dat_all{1,2}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
    neg_r(subject_i2, :) = reshape([dat_all{1,3}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
end


for subject_i2 = 1:sub_num
    max_num = 0;
    min_num = 0;
    for trial_i3 = 1:60
        words{trial_i3, subject_i2};
        if pos_r(subject_i2, trial_i3) >= prctile(pos_r(subject_i2, :), 80)
            max_num = max_num+1;
            max_i = max_i +1;
            pos_max{max_num, A(subject_i2)} = words{trial_i3, subject_i2};
            pos_max{max_num, B(subject_i2)} = pos_r(subject_i2,trial_i3);
            string_posmax{max_i,1} = words{trial_i3, subject_i2};
        elseif pos_r(subject_i2, trial_i3) <= prctile(neg_r(subject_i2, :), 80)
            min_num = min_num+1;
            min_i = min_i +1;
            neg_max{min_num, A(subject_i2)} = words{trial_i3, subject_i2};
            neg_max{min_num, B(subject_i2)} = neg_r(subject_i2,trial_i3);
            string_negmax{min_i,1} = words{trial_i3, subject_i2};
        end
    end
end


% % max word cloud
% string_valmax = cellstr(string_valmax);
% histogram(string_valmax);
% saveas(gcf,fullfile(savedir,'hist_ValenceMax.png'))

string_posmax = categorical(string_posmax);
string_negmax = categorical(string_negmax);
color = [252,141,89]./255;
figure;
wordcloud(string_posmax, 'HighlightColor', color);
title("Positive dim max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_PosMax.png'))


figure;
wordcloud(string_negmax, 'HighlightColor', color);
title("Negative dim max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_NegMax.png'))

close all;


%% type2 safe & threat



saf_r = [];
thr_r = [];
saf_max = [];
thr_max = [];
A = [1:2:sub_num*2-1];
B = [2:2:sub_num*2];
string_safmax = [];
string_thrmax = [];
max_i = 0;
min_i =0;


for subject_i2 = 1:sub_num
    saf_r(subject_i2, :) = reshape([dat_all{1,11}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
    thr_r(subject_i2, :) = reshape([dat_all{1,12}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
end


for subject_i2 = 1:sub_num
    max_num = 0;
    min_num = 0;
    for trial_i3 = 1:60
        words{trial_i3, subject_i2};
        if saf_r(subject_i2, trial_i3) >= prctile(saf_r(subject_i2, :), 80)
            max_num = max_num+1;
            max_i = max_i +1;
            saf_max{max_num, A(subject_i2)} = words{trial_i3, subject_i2};
            saf_max{max_num, B(subject_i2)} = saf_r(subject_i2,trial_i3);
            string_safmax{max_i,1} = words{trial_i3, subject_i2};
        elseif thr_r(subject_i2, trial_i3) <= prctile(thr_r(subject_i2, :), 80)
            min_num = min_num+1;
            min_i = min_i +1;
            thr_max{min_num, A(subject_i2)} = words{trial_i3, subject_i2};
            thr_max{min_num, B(subject_i2)} = thr_r(subject_i2,trial_i3);
            string_thrmax{min_i,1} = words{trial_i3, subject_i2};
        end
    end
end


string_safmax = categorical(string_safmax);
string_thrmax = categorical(string_thrmax);
color = [252,141,89]./255;
figure;
wordcloud(string_safmax, 'HighlightColor', color);
title("Safe max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_safeMax.png'))


figure;
wordcloud(string_thrmax, 'HighlightColor', color);
title("Threat max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_threatMax.png'))

close all;

%% type2 present / future / past

pre_r = [];
fut_r = [];
pas_r = [];
pre_max = [];
fut_max = [];
pas_max = [];
A = [1:2:sub_num*2-1];
B = [2:2:sub_num*2];
string_premax = [];
string_futmax = [];
string_pasmax = [];
pre_i = 0;
fut_i = 0;
pas_i =0;


for subject_i2 = 1:sub_num
    pre_r(subject_i2, :) = reshape([dat_all{1,8}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
    pas_r(subject_i2, :) = reshape([dat_all{1,7}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
    fut_r(subject_i2, :) = reshape([dat_all{1,9}(1+4*(subject_i2-1):4+4*(subject_i2-1),1:15)], 60, 1);
end


for subject_i2 = 1:sub_num
    pre_num = 0;
    fut_num = 0;
    pas_num = 0;
    for trial_i3 = 1:60
        words{trial_i3, subject_i2};
        if pre_r(subject_i2, trial_i3) >= prctile(pre_r(subject_i2, :), 80)
            pre_num = pre_num+1;
            pre_i = pre_i +1;
            pre_max{pre_num, A(subject_i2)} = words{trial_i3, subject_i2};
            pre_max{pre_num, B(subject_i2)} = pre_r(subject_i2,trial_i3);
            string_premax{pre_i,1} = words{trial_i3, subject_i2};
        elseif pas_r(subject_i2, trial_i3) <= prctile(pas_r(subject_i2, :), 80)
            pas_num = pas_num+1;
            pas_i = pas_i +1;
            pas_max{pas_num, A(subject_i2)} = words{trial_i3, subject_i2};
            pas_max{pas_num, B(subject_i2)} = pas_r(subject_i2,trial_i3);
            string_pasmax{pas_i,1} = words{trial_i3, subject_i2};
        elseif fut_r(subject_i2, trial_i3) <= prctile(fut_r(subject_i2, :), 80)
            fut_num = fut_num+1;
            fut_i = fut_i +1;
            fut_max{fut_num, A(subject_i2)} = words{trial_i3, subject_i2};
            fut_max{fut_num, B(subject_i2)} = fut_r(subject_i2,trial_i3);
            string_futmax{fut_i,1} = words{trial_i3, subject_i2};
        end
    end
end



string_pasmax = categorical(string_pasmax);
string_premax = categorical(string_premax);
string_futmax = categorical(string_futmax);
color = [252,141,89]./255;

figure;
wordcloud(string_premax, 'HighlightColor', color);
title("Present max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_PresentMax.png'))


figure;
wordcloud(string_pasmax, 'HighlightColor', color);
title("Past max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_PastMax.png'))

figure;
wordcloud(string_futmax, 'HighlightColor', color);
title("Future max Word Cloud")
saveas(gcf,fullfile(savedir,'type2_WordsCloud_FutureMax.png'))


close all;


%% Words : cross subjectly repeated words & its ratings(same words, various ratings)

C = [];
counts = 0;

for sub = 1:numel(subnames)
    sam = 0;
    for subs = 2:numel(subnames)-1
    countss = 0;
    for trial = 2:60
        for trials = 1:59
        if isequal(words{1, sub}{trial}, words{1, subs}{trials}) && ~isequal(trial, trials) && ~isequal(sub, subs) && ~isequal(words{1,sub}{trial}, '없음') && ~isequal(words{1,sub}{trial}, '??') && ~isequal(words{1,sub}{trial}, '아무생각없음') && ~isequal(words{1,sub}{trial}, 'X') && ~isequal(words{1,sub}{trial}, '건조함') && ~isequal(words{1,sub}{trial}, '소리') && ~isequal(words{1,sub}{trial}, '십자가') && ~isequal(words{1,sub}{trial}, '실험') && ~isequal(words{1,sub}{trial}, '머리')
            counts = counts + 1;
            countss = countss + 1;
            C{counts,1} = words{1,sub}{trial};
            C{counts,2} = countss;
            C{counts,3} = sub;
            C{counts,4} = trial;
            C{counts,5} = subs;
            C{counts,6} = trials;
        end
        end
    end
    end
end

A = categorical(C(:,1));
figure;
AA = histogram(A);


for i = 1:numel(AA.Values)
    if isequal(AA.Values(i), 1) || isequal(AA.Values(i),2)
        for j = 1:size(A,1)
            if isequal(C{j,1}, AA.Categories{i})
                C{j,1} = '없음';
            end
        end
    end
end


for i = 1:size(C,1)
    if isequal(C{i,1}, '없음')
        C(i, :) = [];
    end
end


for i = 1:size(C,1)
    for j = 1:size(C,1)
        if ~isequal(i, j) && isequal(C{i,1}, C{j,1}) && isequal(C{i, 2}, C{j,2})
        C(i, :) = [];
    end
    end
end

for i = 1:size(C,1)
    if isequal(C{i,1}, '커피') || isequal(C{i,1}, '자취방') || isequal(C{i,1}, '영화관') 
        C(i, :) = [];
    end
end

A = categorical(C(:,1));
figure;
AA = histogram(A);

           

% 
% BB = cell(1,1);
% % paste A's contents
% save('pico2_dat_dongju.mat', 'BB');
% histogram(categorical(BB))
%        
%        
%     
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18);
title('repeated words across subjects');

%% Bodymaps : similar emotional ratings + similar body sensation

counts = 0;

for sub = 1:numel(subnames)
    for trials = 1:60
        if isequal(words{1, sub}{trials}, '게임')
            counts = counts +1;
            D{counts, 6} = sub;
            for dim_i = 1:5
                D{counts, dim_i} = ratings{1,sub}{trials+1,dim_i};
            end
        end
    end
end


D(:,6) = []; D = cell2mat(D);

mycolor = [166,206,227; 31,120,180; 178,223,138; 51,160,44; 251,154,153; ...
227,26,28; 253,191,111; 255,127,0; 202,178,214; 106,61,154; ...
55,126,184; 77,175,74; 152,78,163; 27,158,119; 217,95,2; ...
117,112,179; 166,86,40; 247,129,191; 153,153,153; 166,206,227; 31,120,180;]./255;


E = boxplot_wani_2016(D, 'color', mycolor, 'dots', 'nobox', 'violin');
%{'valence'}    {'self'  }    {'time'   }    {'safety-threat'}    {'safety-threat'}    {[ 3]}

set(gca,'XTickLabel',{'valence'; 'self-relevance'; 'time'; 'vividness'; 'safety-threat'});
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',28);
title('5dims Ratings for Repeated Word : 게임');

%% find x and ����



datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subnames = subnames(1:19); % 1: numel(subnames)-# of extracted sub

x = 0;
xindex = cell(1,1);

for trial = 1:60
    for sub = 1: 19
        if isequal(words{trial, sub}, "X") ||  isequal(words{trial, sub}, "??") 
            x = x + 1;
            xindex{x,1} = trial;
            xindex(x,2) = subnames(sub);
         end
    end
end

% x, X, ?, ??, ??? 10��
% ���� / �ƹ��������� / �ƹ��������� / �����̾ȳ���(coco013)

for trial = 1:60
    for sub = 1: 19
         if isequal(words{trial, sub}, "����") ||  isequal(words{trial, sub}, "����")
            x = x + 1;
            xindex{x,1} = trial;
            xindex(x,2) = subnames(sub);
         end
    end
end


% for w_i = 1:19, for w_ii = 1:60, W{w_ii + 60*(w_i-1)}=words{1,w_i}{w_ii}; end, end


