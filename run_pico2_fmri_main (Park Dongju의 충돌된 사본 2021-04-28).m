%% Set directory and register participant 
clear;
[basedir, sid, subject_dir] = pico2_directory_sub_info('WL01'); 
% 'exp_room', 'dj_mac', 'WL01', 'BE_imac' 'int01', 'hj_mac','hm_mac', 'je_mac'
cd(basedir);

%% ---------------------- %%
%  ---- fMRI tasks  -----  %
%  ----------------------  %
%% Resting (N = 1, 2) 
cd(basedir); 
pico2_fmri_resting(basedir, sid, 'biopac');

%% FREE THINKING (N = 1, 2, 3, 4)
cd(basedir);
pico2_fmri_free_thinking(basedir, sid, 'biopac'); % , 'biopac'); %, 'hs/dc' 

%% ---------------------- %%
%  -- experimental code -- %
%  ---- during fMRI -----  %
%  ----------------------  %

%% Word sampling result (INPUT WORDS) (N = 1, 2, 3, 4)
cd(basedir);
pico2_wordsampling(basedir, sid);    

%% Edit words (if needed)
cd(basedir);
pico2_editwords(basedir, sid);

%% ----------------------- %%
%  -- Post-scan Ratings --  %
%  -----------------------  %
%% Type1: word segmentation
pico2_post_type01_word_segmentation(basedir, sid);

%% Type2: WORD SURVEY (19 dimensions)
cd(basedir);
words = pico2_wholewords(basedir, sid); words'
% load(fullfile(basedir, 'dims_anchor_korean.mat')); % dims,1 anchor, 
survey = pico2_post_type02_word_survey(basedir, sid, words); % ,'mgkey'); 

%% Type3: Word survey (5 dime rba aaaaaaraaaaaaaaaa  aaaaaaaaaraaaraaraa  aaaaaaaaaaaaraaa  aaaaaaaaaaaaaaaa  nsions + Bodymap) 
cd(basedir);  
words = pico2_wholewords(basedir, sid);   
pico2_post_type03_fast_word_survey(basedir, sid(1:7), words); %, 'mgkey'); 