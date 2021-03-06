function pico2_fmri_resting(basedir, sid, varargin)


%% DEFAULT

global USE_EYELINK USE_BIOPAC

testmode = false;
USE_EYELINK = false;
USE_BIOPAC = false;

datdir = fullfile(basedir, 'data');
subject_dir = fullfile(datdir, sid);

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

%% GET RUN NUMBER

run_num = input('Resting Run number? (n = 1(pre-resting), 2(post-resting)): ');

%% CREATE AND SAVE DATA

[~, sid] = fileparts(subject_dir);

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_', sid, '_resting_run', sprintf('%.2d', run_num), '.mat']);
data.version = 'PICO2_v1_06-2020_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;
data.run_number = run_num;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', [subjdate, '_', sid, '_FT_run', sprintf('%.2d', run_num), '.mat']);
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
msg.hs_dc = double('스캐너 조정 작업중입니다.\n 소음이 발생할 수 있습니다. 화면 중앙의 십자표시를\n 편안한 마음으로 바라봐주세요.'); % head scout and distortion correction

msg.s_key = double('참가자가 준비되었으면, \n 이미징을 시작합니다 (s).');
msg.s_key2 = double('이번 세션은 휴식 세션입니다. \n 화면에 나타는 + 표시를 바라보며, 움직이지 말고 가만히 있어주세요. \n\n 참가자가 준비되었으면 이미징을 시작합니다. (s)') ;

msg.start_buffer = double('시작합니다...');

msg.ThoughtSampling = double('지금 무슨 생각을 하고 있는지 \n 단어나 구로 말해주세요.');
msg.fixation = double('+');

msg.postQ_inst = double('이번 세션이 끝났습니다. \n 나타나는 질문들에 답변해주세요.');

msg.run_end = double('잘하셨습니다. 잠시 대기해 주세요.');

msg.survey.intro_prompt1 = double('방금 휴식 과제를 하는동안 자연스럽게 떠올린 생각에 대한 질문입니다.') ;

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
    
    %% HEAD SCOUT AND DISTORTION CORRECTION
    if run_num == 1 % the first run
        while (1)
            
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('a'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment('manual');
            end
            
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, msg.hs_dc,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
            Screen('Flip', theWindow);
            
        end
        
        WaitSecs(0.5);
        
        while (1)
            
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('b'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment('manual');
            end
            
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, msg.fixation,'center', 'center', white); %'center', 'textH'
            Screen('Flip', theWindow);
            
        end
        
        WaitSecs(0.5);
        
    end
    
    %% Start FT session
    
    % INPUT (s key) FROM THE SCANNER
    
    while (1)
        
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('s'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        if run_num == 1
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, msg.s_key,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
            Screen('Flip', theWindow);
            
        else
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            DrawFormattedText(theWindow, msg.s_key2, 'center', 'center', text_color, [], [], [], 1.3);
            Screen('Flip', theWindow);
            
        end
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
    
    % biopac
    % eyelink
    
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
    
    %% START resting
    
    % 8 seconds for being ready
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 16); % after 8 seconds of disdaq, 8 seconds of baseline
    
    data.resting_start_time = GetSecs;
    
    data = pico_resting(data, msg); % resting
    
    save(data.datafile, 'data', '-append');
    data.resting_end_time = GetSecs;
    
    data.runscan_endtime = GetSecs;

    while GetSecs - data.resting_end_time < 3
        DrawFormattedText(theWindow, msg.postQ_inst, 'center', 'center', text_color, [], [], [], 1.5);
        Screen('Flip', theWindow);
    end
    
    data = pico_post_run_survey_resting(data, msg);
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


function data = pico_resting(data, msg)

global theWindow W H; % window property
global fontsize window_rect text_color textH % lb tb recsize barsize rec; % rating scale

fixation_point = double('+') ;
Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.resting.fixation_start_time = resting_sTime;

rng('shuffle')

resting_total_time = 14*50+15+5; % same with FT runs

Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, msg.fixation, 'center', 'center', text_color);
Screen('Flip', theWindow);

waitsec_fromstarttime(resting_sTime, resting_total_time);

data.resting.fixation_end_time = GetSecs;

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

function data = pico_post_run_survey_resting(data, msg)

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
DrawFormattedText(theWindow, msg.survey.intro_prompt1,'center', H/5-80, white);

rng('shuffle');
z = randperm(6);
barsize = barsizeO(:,z);
title = msg.survey.title(:,z);


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
            DrawFormattedText(theWindow, msg.survey.intro_prompt1,'center', H/5-80, white)
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
                DrawFormattedText(theWindow, msg.survey.intro_prompt1,'center', H/5-80, white)
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

