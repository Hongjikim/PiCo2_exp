function pico2_fmri_free_speech(basedir, varargin)


%% DEFAULT

global USE_EYELINK USE_BIOPAC

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

datdir = fullfile(basedir, 'data');

%% PARSING VARARGIN

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'test', 'testmode'}
                testmode = true;
            case {'eyelink', 'eye', 'eyetrack'}
                USE_EYELINK = true;
            case {'biopac'}
                USE_BIOPAC = true;
                channel_n = 1;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
        end
    end
end

%% LOAD TRIAL SEQUENCE AND GET RUN NUMBER

sid = input('Subject ID? (e.g., coco001_khj): ', 's');

subject_dir = fullfile(datdir, sid);

if exist(subject_dir, 'dir') == 0 % no subject dir
    mkdir(subject_dir);
end

run_num = input('FREE Speech Run number? (n = 1, 2, 3): ');

%% CREATE AND SAVE DATA

[~, sid] = fileparts(subject_dir);

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_', sid, '_FS_run', sprintf('%.2d', run_num), '.mat']);
data.version = 'PICO2_v1_06-2020_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;
data.run_number = run_num;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', [subjdate, '_', sid, '_FS_run', sprintf('%.2d', run_num), '.mat']);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Break.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

%% preallocate seed words

fname_words = filenames(fullfile(subject_dir, ['THOUGHT_SAMPLING*.mat']));

whole_words = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    whole_words(r,:)=response;
end

seedwords.given = {'눈물', '학대', '거울', '가족'};

while true
    seedwords.personal = whole_words(randperm(numel(whole_words),4));
    
    fprintf('\n ** check seed words %s ', string(seedwords.personal));
    ok_or_not = input(['\n okay to proceed?', ...
        '\n1: Yes.  ,   2: No, pick words again.\n:  ']);
    if ok_or_not == 1
        break
    end
end

%% EXPERIMENT START

%SETUP: global

global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect text_color % lb tb recsize barsize rec; % rating scale

% Screen setting
bgcolor = 50;

if testmode == true
    window_ratio = 1.6;
else
    window_ratio = 1;
end

text_color = 255;
fontsize = [28, 32, 41, 54];
%fontsize = 42; %60?

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width/window_ratio window_info.height/window_ratio]; %for mac, [0 0 2560 1600];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];

%% KOREAN INSTRUCTIONS
msg.inst1 = double('이번 세션은 자유 말하기 세션입니다. \n 화면에 나타난 단어에 대해 자유롭게 생각하시다가 지시문이 나왔다가 사라지면 이야기를 시작해주세요 \n\n 연습을 한번 해보겠습니다.') ;
msg.inst2 = double('잘하셨습니다. 세션을 시작하겠습니다.');

msg.start_buffer = double('시작합니다...');
msg.fixation = double('+');

msg.s_key = double('이번 세션은 자유 말하기 세션입니다. \n 화면에 나타난 단어에 대해 자유롭게 생각하시다가 지시문이 나왔다가 사라지면 이야기를 시작해주세요 \n\n 참가자가 준비되었으면 이미징을 시작합니다. (s)') ;
msg.fs_inst1 = double('아래 단어에 대해 생각해주세요 \n\n');
msg.fs_inst2 = double('+ 표시가 나타나면, 방금 보신 단어에 대해 자유롭게 이야기해주세요. \n + 표시가 사라질 때 까지 계속 이야기해주세요');
msg.fs_inst3 = double('잘하셨습니다. 다음 단어로 넘어가겠습니다. \n 잠시 대기해주세요.');

msg.postQ_inst = double('이번 세션이 끝났습니다. \n 나타나는 질문들에 답변해주세요.');
msg.run_end = double('잘하셨습니다. 잠시 대기해 주세요.');

msg.survey.intro_prompt1 = double('방금 자유 생각 과제를 하는동안 자연스럽게 떠올린 생각에 대한 질문입니다.') ;

msg.survey.title={'','', '','', '', '';
    '부정', '전혀 나와\n관련이 없음', '과거', '전혀 생생하지 않음', '위협', '';
    '중립', '', '현재', '', '중립', '';
    '긍정','나와 관련이\n매우 많음', '미래','매우 생생함','안전','';
    '느껴지는 감정', '자신과 관련이 있는 정도', '가장 관련이 있는 자신의 시간', ...
    '어떤 상황이나 장면을\n얼마나 생생하게 떠올리게 하는지', '안전 또는 위협을\n의미하거나 느끼게 하는지', '';
    '그 생각이 일으킨 감정은?', '그 생각이 나와 관련이 있는 정도는?', '그 생각이 가장 관련이 있는 자신의 시간?', ...
    '그 생각이 어떤 상황이나 장면을\n생생하게 떠올리게 했나요?', '그 생각이 안전 또는 위협을\n의미하거나 느끼게 했나요?',''};

%% FULL SCREEN

try
    
    [theWindow, ~] = Screen('OpenWindow',0, bgcolor, window_rect);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    Screen('TextSize', theWindow, fontsize(3));
    if ~testmode, HideCursor; end
    
    %% SETUP: Eyelink
    % need to be revised when the eyelink is here.
    if USE_EYELINK
        edf_filename = ['E' sid(5:7), '_F' sprintf('%.1d', run_num)]; % name should be equal or less than 8
        % E_F for Free_thinking
        edfFile = sprintf('%s.EDF', edf_filename);
        eyelink_main(edfFile, 'Init');
        
        status = Eyelink('Initialize');
        if status
            error('Eyelink is not communicating with PC. Its okay baby.');
        end
        Eyelink('Command', 'set_idle_mode');
        waitsec_fromstarttime(GetSecs, .5);
    end
    
    %% Practice
    while (1)
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, msg.inst1,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
        Screen('Flip', theWindow);
        
    end
    
    WaitSecs(0.5);
    
    while (1)
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, msg.fs_inst1,'center', 'center', white);
        DrawFormattedText(theWindow, double('사랑'),'center', 'center', white);
        Screen('Flip', theWindow);
        
    end
    
    WaitSecs(0.5);
    
    temp_t = GetSecs;
    while GetSecs - temp_t < 5
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, msg.fs_inst2,'center', 'center', white);
        Screen('Flip', theWindow);
        
    end
    
    temp_t = GetSecs;
    while GetSecs - temp_t < 30
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, msg.fixation,'center', 'center', white);
        Screen('Flip', theWindow);
        
    end
    
    WaitSecs(0.5);
    
    while (1)
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('c'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        DrawFormattedText(theWindow, msg.inst2, 'center', 'center', text_color, [], [], [], 1.5);
        Screen('Flip', theWindow);
        
    end
    
    WaitSecs(0.5);
    
    
    %% Start free speech session
    
    % INPUT (s key) FROM THE SCANNER
    
    while (1)
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('s'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, msg.s_key, 'center', 'center', text_color, [], [], [], 1.3);
        Screen('Flip', theWindow);
        
    end
    
    %% For DISDAQ
    
    % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
    % 4 seconds: "?????⑸????..."
    
    data.runscan_starttime = GetSecs; % run start timestamp
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, msg.start_buffer, 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 4);
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 8); % 8 seconds for disdaq
    
    %% EYELINK AND BIOPAC START
    
    if USE_EYELINK
        Eyelink('StartRecording');
        data.eyetracker_starttime = GetSecs; % eyelink timestamp
        Eyelink('Message','FT Run start');
    end
    
    if USE_BIOPAC
        data.biopac_starttime = GetSecs; % biopac timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(data.biopac_starttime, 1); % biopac start trigger: 1
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    %% START FREE THINKING
    
    % 8 seconds for being ready
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 16); % after 8 seconds of disdaq, 8 seconds of baseline
    
    data.freespeech_start_time = GetSecs;
    
    data = free_speech(data, seedwords, msg); % free speech tasks
    
    save(data.datafile, 'data', '-append');
    data.freespeech_end_time = GetSecs;
    
    while GetSecs - data.freespeech_end_time < 3
        DrawFormattedText(theWindow, msg.postQ_inst, 'center', 'center', text_color, [], [], [], 1.5);
        Screen('Flip', theWindow);
    end
    
    data = pico_post_run_survey_resting(data, seedwords, msg);
    save(data.datafile, 'data', '-append');
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, msg.run_end, 'center', textH, white);
    Screen('Flip', theWindow);
    
    if USE_EYELINK
        Eyelink('Message','Story Run END');
        eyelink_main(edfFile, 'Shutdown');
    end
    if USE_BIOPAC
        data.biopac_endtime = GetSecs; % biopac timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        ending_trigger =  0.1 * run_num; % biopac run ending trigger: 0.1 * run_number
        waitsec_fromstarttime(data.biopac_endtime, ending_trigger);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    data.run_endtime_getsecs = GetSecs;
    save(data.datafile, 'data', '-append');
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        end
    end
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    
catch err
    
    % ERROR
    disp(err);
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    %     fclose(t);
    %     fclose(r);  % Q??
    abort_experiment('error');
end

end



%% ====== SUBFUNCTIONS ======


function data = free_speech(data, seedwords, msg)

global theWindow W H; % window property
global fontsize window_rect text_color textH % lb tb recsize barsize rec; % rating scale

% blank
Screen(theWindow,'FillRect',bgcolor, window_rect);
Screen('Flip', theWindow);

fs_sTime = GetSecs;
data.FSfunction.blank_start_time = fs_sTime;

rng('shuffle')

n_trial = numel(seedwords.personal)+numel(seedwords.given);
order_idx = zeros(1,n_trial);
while mean(order_idx(1:4)) < 3 || mean(order_idx(5:8)) < 3 
    order_idx = randperm(n_trial);
end

for w = 1:n_trial
    if order_idx(w) < 5
        word_list{w} = seedwords.given{order_idx(w)};
    else
        word_list{w} = seedwords.personal{order_idx(w)-4};
    end
end

% time
% think: 20, cue: 5, +: 60, next: 10 --> total 95
fs_total_time = n_trial*95;
base_time = 0:95:fs_total_time-95;
base_time(2) = 2;

jitter = randi([-5 5],1,n_trial);

%  for i = 1:n_trial
%      trial_sTime = GetSecs;
%      
%      while GetSecs - trial_sTime < base_time(i) + 20 + jitter(i) % 20 seconds "think"
%      
%          Screen(theWindow, 'FillRect', bgcolor, window_rect);
%          DrawFormattedText(theWindow, msg.fs_inst1,'center', 'center', white);
%          DrawFormattedText(theWindow, double(word_list{i}),'center', 'center', white);
%          Screen('Flip', theWindow);
%      
%      end
%      
%      while GetSecs - trial_sTime < base_time(i) + 20 + jitter(i) % 20 seconds "think"
%      
%          Screen(theWindow, 'FillRect', bgcolor, window_rect);
%          DrawFormattedText(theWindow, msg.fs_inst1,'center', 'center', white);
%          DrawFormattedText(theWindow, double(word_list{i}),'center', 'center', white);
%          Screen('Flip', theWindow);
%      
%      end
%         
%         
%     end
% end

data.FTfunction.fixation_end_time = GetSecs;

% last trial
while GetSecs - data.FTfunction.fixation_end_time <5
    
    k = k +1;
    if k == 1
        data.FTfunction.start_Sampling{i+1} = GetSecs;
    end
    data.FTfunction.end_Sampling{i+1} = GetSecs;
    
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, msg.ThoughtSampling, 'center', 'center', text_color, [], [], [], 1.5);
    Screen('Flip', theWindow);
    
end

data.FTfunction.last_sampling_end_time = GetSecs;


% after last trial, wait for 15 seconds

while GetSecs - data.FTfunction.last_sampling_end_time < 15
    
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, msg.fixation, 'center', 'center', text_color);
    Screen('Flip', theWindow);
    
end
data.runscan_endtime = GetSecs;
end

function abort_experiment(varargin)

% ABORT the experiment
%
% abort_experiment(varargin)

str = 'Experiment aborted.';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'error'}
                str = 'Experiment aborted by error.';
            case {'manual'}
                str = 'Experiment aborted by the experimenter.';
        end
    end
end

ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end

function data = pico_post_run_survey_resting(data, seedwords, msg)

global theWindow W H; % window property
global white red orange bgcolor tb rec recsize; % color
global window_rect USE_EYELINK
global fontsize barsize

%tb = H/5;
rT_post = Inf;

lb=300; %W*3/128;     %110        when W=1280
tb=300; %H*12/80;     %180

recsize=[W*450/1280 H*175/1000];
barsizeO=[W*340/1280, W*180/1280, W*340/1280, W*180/1280, W*340/1280, 0;
    10, 10, 10, 10, 10, 0; 10, 0, 10, 0, 10, 0;
    10, 10, 10, 10, 10, 0; 1, 2, 3, 4, 5, 0]*1;
rec=[lb,tb; lb+recsize(1),tb; lb,tb+recsize(2); lb+recsize(1),tb+recsize(2);
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)];

% trajectory = [];
% trajectory_time = [];
%
% j = 0;
post_run.start_time = GetSecs;
question_type = {'Valence','Self-relevance','Time','Vividness','Safe&Threat'};

% save(data.datafile, 'data', '-append');

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, fontsize(2));
DrawFormattedText(theWindow, survey_msg.intro_prompt1,'center', H/5-80, white);

rng('shuffle');
z = randperm(6);
barsize = barsizeO(:,z);
title = survey_msg.title(:,z);


linexy = zeros(2,48);

for i=1:6       % 6 lines
    linexy(1,2*i-1)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,2*i)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(2,2*i-1) = rec(i,2)+recsize(2)/2;
    linexy(2,2*i) = rec(i,2)+recsize(2)/2;
end

for i=1:6       % 3 scales for one line, 18 scales
    linexy(1,6*(i+1)+1)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,6*(i+1)+2)= rec(i,1)+(recsize(1)-barsize(1,i))/2;
    linexy(1,6*(i+1)+3)= rec(i,1)+recsize(1)/2;
    linexy(1,6*(i+1)+4)= rec(i,1)+recsize(1)/2;
    linexy(1,6*(i+1)+5)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(1,6*(i+1)+6)= rec(i,1)+(recsize(1)+barsize(1,i))/2;
    linexy(2,6*(i+1)+1)= rec(i,2)+recsize(2)/2-barsize(2,i)/2;
    linexy(2,6*(i+1)+2)= rec(i,2)+recsize(2)/2+barsize(2,i)/2;
    linexy(2,6*(i+1)+3)= rec(i,2)+recsize(2)/2-barsize(3,i)/2;
    linexy(2,6*(i+1)+4)= rec(i,2)+recsize(2)/2+barsize(3,i)/2;
    linexy(2,6*(i+1)+5)= rec(i,2)+recsize(2)/2-barsize(4,i)/2;
    linexy(2,6*(i+1)+6)= rec(i,2)+recsize(2)/2+barsize(4,i)/2;
end

Screen('Flip', theWindow);

for j=1:numel(barsize(5,:))
    if ~barsize(5,j) == 0 % if barsize(5,j) = 0, skip the scale
        % if Self, Vivid question, set cursor on the left.
        % the other, set curson on the center.
        if mod(barsize(5,j),2) == 0
            SetMouse(rec(j,1)+(recsize(1)-barsize(1,j))/2, rec(j,2)+recsize(2)/2);
        else
            SetMouse(rec(j,1)+recsize(1)/2, rec(j,2)+recsize(2)/2);
        end
        
        rec_i = 0;
        post_run.dat{barsize(5,j)}.trajectory = [];
        post_run.dat{barsize(5,j)}.time = [];
        post_run.dat{barsize(5,j)}.question_type = question_type{z(j)};
        
        starttime = GetSecs; % Each question start time
        
        while(1)
            
            % Draw scale lines
            Screen('DrawLines',theWindow, linexy, 4, 255);
            Screen('TextSize', theWindow, fontsize(2));
            DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white)
            % Draw scale letter
            
            for i = 1:numel(title(1,:))
                Screen('TextSize', theWindow, fontsize(1));
                DrawFormattedText(theWindow, double(title{1,i}),'center', 'center', white, [],[],[],[],[],...
                    [rec(i,1), rec(i,2)+5, rec(i,1)+recsize(1), rec(i,2)+recsize(2)/2]);
                Screen('TextSize', theWindow, fontsize(1)-5);
                DrawFormattedText(theWindow, double(title{2,i}),'center', 'center', white, [],[],[], 1.5,[],...
                    [linexy(1,2*i-1)-15, linexy(2,2*i-1), linexy(1,2*i-1)+20, linexy(2,2*i-1)+80]);
                DrawFormattedText(theWindow, double(title{3,i}),'center', 'center', white, [],[],[], 1.5,[],...
                    [rec(i,1)+recsize(1)/3, linexy(2,2*i-1), rec(i,1)+recsize(1)*2/3, linexy(2,2*i-1)+80]);
                DrawFormattedText(theWindow, double(title{4,i}),'center', 'center', white, [],[],[],1.5,[],...
                    [linexy(1,2*i)-20, linexy(2,2*i-1), linexy(1,2*i)+15, linexy(2,2*i-1)+80]);
            end
            
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;  % x of a color dot
            y = rec(j,2)+recsize(2)/2;
            if x < rec(j,1)+(recsize(1)-barsize(1,j))/2, x = rec(j,1)+(recsize(1)-barsize(1,j))/2;
            elseif x > rec(j,1)+(recsize(1)+barsize(1,j))/2, x = rec(j,1)+(recsize(1)+barsize(1,j))/2;
            end
            
            %                     % display scales and cursor
            %                     a_display_survey(z, seeds_i, target_i, words','whole');
            %Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, orange);
            Screen('Flip', theWindow);
            
            % Get trajectory
            rec_i = rec_i+1; % the number of recordings
            post_run.dat{barsize(5,j)}.trajectory(rec_i,1) = rating_5d(x, j);
            post_run.dat{barsize(5,j)}.time(rec_i,1) = GetSecs - starttime;
            
            if GetSecs - starttime >= rT_post
                post_run.dat{barsize(5,j)}.button_press = false;
                button(1) = true;
            end
            
            if button(1)
                
                % Draw scale lines
                Screen('DrawLines',theWindow, linexy, 4, 255);
                Screen('TextSize', theWindow, fontsize(2));
                DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white)
                % Draw scale letter
                
                for i = 1:numel(title(1,:))
                    Screen('TextSize', theWindow, fontsize(1));
                    DrawFormattedText(theWindow, double(title{1,i}),'center', 'center', white, [],[],[],[],[],...
                        [rec(i,1), rec(i,2)+5, rec(i,1)+recsize(1), rec(i,2)+recsize(2)/2]);
                    Screen('TextSize', theWindow, fontsize(1)-5);
                    DrawFormattedText(theWindow, double(title{2,i}),'center', 'center', white, [],[],[], 1.5,[],...
                        [linexy(1,2*i-1)-15, linexy(2,2*i-1), linexy(1,2*i-1)+20, linexy(2,2*i-1)+80]);
                    DrawFormattedText(theWindow, double(title{3,i}),'center', 'center', white, [],[],[],1.5,[],...
                        [rec(i,1)+recsize(1)/3, linexy(2,2*i-1), rec(i,1)+recsize(1)*2/3, linexy(2,2*i-1)+80]);
                    DrawFormattedText(theWindow, double(title{4,i}),'center', 'center', white, [],[],[],1.5,[],...
                        [linexy(1,2*i)-20, linexy(2,2*i-1), linexy(1,2*i)+15, linexy(2,2*i-1)+80]);
                end
                
                post_run.dat{barsize(5,j)}.rating = rating_5d(x, j);
                post_run.dat{barsize(5,j)}.RT = post_run.dat{barsize(5,j)}.time(end) - ...
                    post_run.dat{barsize(5,j)}.time(1);
                
                %                         a_display_survey(z, seeds_i, target_i, words','whole');
                %Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                %Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, orange);
                Screen('DrawLines', theWindow, [x, x; y+10 y-10], 6, red);
                
                Screen('Flip', theWindow);
                
                WaitSecs(.3);
                break;
            end
        end
    end
end

post_run.response_endtime = GetSecs;
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);
waitsec_fromstarttime(post_run.response_endtime, 2)

post_run.end_time = GetSecs;

data.postrunQ = post_run;

save(data.datafile, 'data', '-append');

end

