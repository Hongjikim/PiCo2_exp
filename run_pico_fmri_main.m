%% Run PiCo 2 experiment

%% FREE THINKING (N = 1, 2, 3)

clear;

basedir = set_directory('dj_mac'); % 'dj_mac', 'WL01'
cd(basedir);

%%
pico_fmri_resting_v2(basedir);% 'test', 'biopac'

%% INPUT WORDS (N = 1, 2, 3)

cd(basedir);
pico_wordsampling(basedir);     

%% WORD SURVEY
cd(basedir);
[words, sid] = pico_wholewords(basedir);
a_fast_fmri_survey(basedir, sid, words); % body map  right
