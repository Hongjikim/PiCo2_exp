%% Set directory for PiCo2 
clear;
basedir = pico2_set_directory('hj_mac'); % 'dj_mac', 'WL01', 'BE_imac' 'int01', 'hj_mac'
cd(basedir);

%% Resting (N = 1, 2)
cd(basedir);
pico2_fmri_resting(basedir); % 'biopac' % TR = 616 seconds (1340)

%% FREE THINKING (N = 1, 2, 3, 4)

cd(basedir);
pico2_fmri_free_thinking(basedir); % 'biopac', 'hc/dc'

%% INPUT WORDS (N = 1, 2, 3, 4)

cd(basedir);
pico2_wordsampling(basedir);     

%% WORD SURVEY
cd(basedir);
[words, sid] = pico2_wholewords(basedir);

%%
a_fast_fmri_survey(basedir, sid, words); %, 'mgkey'); % if using magic keyboard, add 'mgkey'
