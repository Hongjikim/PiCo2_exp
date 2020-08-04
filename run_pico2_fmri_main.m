%% Set directory for PiCo2 
clear;
basedir = pico2_set_directory('hj_mac'); % 'dj_mac', 'WL01', 'BE_imac' 'int01', 'hj_mac'
cd(basedir);

%% Resting (N = 1, 2)
cd(basedir);
pico2_fmri_resting(basedir); % 'biopac' % TR = 616 seconds (1340)

%% FREE THINKING (N = 1, 2, 3, 4)

cd(basedir);
pico2_fmri_free_thinking(basedir, 'biopac'); % 'biopac', 'hc/dc'

%% INPUT WORDS (N = 1, 2, 3, 4)

cd(basedir);
pico2_wordsampling(basedir);     

%% WORD SURVEY
cd(basedir);
[words, sid_short] = pico2_wholewords(basedir);

%%
words{1,7} = '���̻�����ĥ��'; words{1,10} = '���̻�����ĥ�ȱ��ʽ��Ͻ���';
pico2_word_survey_v2(basedir, sid_short, words)

% if mistake, go back
% save response
%%
a_fast_fmri_survey(basedir, sid_short, words); %, 'mgkey'); % if using magic keyboard, add 'mgkey'
