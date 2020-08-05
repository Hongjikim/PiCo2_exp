%% Set directory and register participant 
clear;
[basedir, sid, subject_dir] = pico2_directory_sub_info('hj_mac'); % 'dj_mac', 'WL01', 'BE_imac' 'int01'
cd(basedir);

%% Resting (N = 1, 2)
cd(basedir);
pico2_fmri_resting(basedir, sid); %'biopac' % TR = 616 seconds (1340)

%% FREE THINKING (N = 1, 2, 3, 4)

cd(basedir);
pico2_fmri_free_thinking(basedir, sid); % 'biopac', 'hs/dc' 

%% INPUT WORDS (N = 1, 2, 3, 4)

cd(basedir);
pico2_wordsampling(basedir, sid);    

%% edit words
pico2_editwords(basedir, sid)

%% WORD SURVEY
cd(basedir);
words = pico2_wholewords(basedir, sid);

%%
words{1,7} = '¿œ¿ÃªÔªÁø¿¿∞ƒ•∆»'; words{1,10} = '¿œ¿ÃªÔªÁø¿¿∞ƒ•∆»±∏Ω Ω ¿œΩ ¿Ã';
survey = pico2_word_survey_v2(basedir, sid, words); % if restart: use 'run_number', 2

% todo: 1) if mistake, go back

%%
a_fast_fmri_survey(basedir, sid_short, words); %, 'mgkey'); % if using magic keyboard, add 'mgkey'
