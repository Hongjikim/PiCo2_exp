%% Set directory and register participant 
clear;
[basedir, sid, subject_dir] = pico2_directory_sub_info('exp_room'); % 'exp_room', 'dj_mac', 'WL01', 'BE_imac' 'int01'
cd(basedir);

%% Resting (N = 1, 2)
cd(basedir);
pico2_fmri_resting(basedir, sid, 'biopac'); %, 'biopac') % TR = 616 seconds (1340)

%% FREE THINKING (N = 1, 2, 3, 4)

cd(basedir);
pico2_fmri_free_thinking(basedir, sid, 'biopac'); % , 'biopac'); %, 'hs/dc' 

%% INPUT WORDS (N = 1, 2, 3, 4)

cd(basedir);
pico2_wordsampling(basedir, sid);    

%% edit words
pico2_editwords(basedir, sid)

%% word segmentation
pico2_word_segmentation(basedir, sid);

%% WORD SURVEY
cd(basedir);
words = pico2_wholewords(basedir, sid);

%%
load('dims_anchor_korean.mat'); % load('dims_anchor_english.mat') 
survey = pico2_word_survey(basedir, sid, words, dims, anchor, 'mgkey'); %, 'mgkey'); % if restart: use 'run_number', 2

%%
a_fast_fmri_survey(basedir, sid(1:7), words); %, 'mgkey'); % if using magic keyboard, add 'mgkey'

%% viz survey response

clf; for i = 1:19, subplot(5,4,i), plot(survey.dat.response{i}); end
clf; for i = 5:7, plot(survey.dat.response{i}); hold on; end
