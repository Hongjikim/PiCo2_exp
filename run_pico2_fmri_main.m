%% Run PiCo 2 experiment

%% FREE THINKING (N = 1, 2, 3)

clear;
basedir = pico2_set_directory('WL01'); % 'dj_mac', 'WL01'
cd(basedir);

%%
pico2_fmri_free_thinking(basedir);% , 'biopac'); % , 'biopac');% 'test', 'biopac'

%% INPUT WORDS (N = 1, 2, 3)

cd(basedir);
pico2_wordsampling(basedir);     

%% WORD SURVEY
cd(basedir);
[words, sid] = pico2_wholewords(basedir);
a_fast_fmri_survey(basedir, sid, words); % body map right boundary