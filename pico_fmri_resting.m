function pico_fmri_resting(basedir, varargin)


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

subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');

if size(subject_dir,1) == 1
    if contains(subject_dir, 'no matches found') % mac: no subject dir
        mkdir(fullfile(datdir, sid)); % make subject directory
    elseif contains(subject_dir, '������ ã�� �� �����ϴ�.') % mac: no subject dir
        mkdir(fullfile(datdir, sid)); % make subject directory
    end
elseif size(subject_dir,1)>1
    error('There are more than one subject directory. Please check and delete the wrong directory.')
elseif size(subject_dir,1) == 0 % in WL01
    mkdir(fullfile(datdir, sid)); % make subject directory
end


ft_num = input('FREE THKINING Run number? (n = 1, 2, 3): ');

%% CREATE AND SAVE DATA

[~, sid] = fileparts(subject_dir);

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = sid;
data.datafile = fullfile(subject_dir, [subjdate, '_', sid, '_FT_run', sprintf('%.2d', ft_num), '.mat']);
data.version = 'PICO2_v1_06-2020_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;
data.run_number = ft_num;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', [subjdate, '_', sid, '_FT_run', sprintf('%.2d', ft_num), '.mat']);
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

%% FULL SCREEN

try
    
    [theWindow, ~] = Screen('OpenWindow',0, bgcolor, window_rect);%[0 0 2560/2 1440/2]
    Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
    Screen('TextSize', theWindow, fontsize(3));
    if ~testmode, HideCursor; end
    
    %% SETUP: Eyelink
    % need to be revised when the eyelink is here.
    if USE_EYELINK
        edf_filename = ['E' sid(5:7), '_F' sprintf('%.1d', ft_num)]; % name should be equal or less than 8
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
    if ft_num == 1 % the first run
        while (1)
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('a'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment('manual');
            end
            
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            ready_prompt = double('��ĳ�� ���� �۾����Դϴ�.\n ������ �߻��� �� �ֽ��ϴ�. ȭ�� �߾��� ����ǥ�ø�\n ����� �������� �ٶ���ּ���.');
            DrawFormattedText(theWindow, ready_prompt,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
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
            ready_prompt = double('+');
            DrawFormattedText(theWindow, ready_prompt,'center', 'center', white); %'center', 'textH'
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
            
            start_msg = double('�̹� ������ ���� ���� �����Դϴ�. \n ȭ�鿡 + ǥ�ð� ��Ÿ����, ���� ������ �����ϼ���. \n + ǥ�ð� ����� ������ ���ù��� �亯�� ���ּ���.\n\n ������ �ѹ� �غ��ڽ��ϴ�.') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color, [], [], [], 1.5);
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
            
            start_msg = double('+') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color, [], [], [], 1.5);
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
            FT_msg = double('���� ���� ������ �ϰ� �ִ��� \n �ܾ ���� �����ּ���.') ;
            DrawFormattedText(theWindow, FT_msg,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
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
            FT_msg = double('���ϼ̽��ϴ�. ������ �����ϰڽ��ϴ�.') ;
            DrawFormattedText(theWindow, FT_msg,'center', 'center', white); %'center', 'textH'
            Screen('Flip', theWindow);
            
        end
        WaitSecs(0.5);
    end
    
    %% Start FT session
    
    %INPUT FROM THE SCANNER
    while (1)
        [~,~,keyCode] = KbCheck;
        
        if keyCode(KbName('s'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment('manual');
        end
        
        if ft_num == 1
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            ready_prompt = double('�����ڰ� �غ�Ǿ�����, \n �̹�¡�� �����մϴ� (s).');
            DrawFormattedText(theWindow, ready_prompt,'center', 'center', white, [], [], [], 1.5); %'center', 'textH'
            Screen('Flip', theWindow);
            
        else
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            start_msg = double('�̹� ������ ���� ���� �����Դϴ�. \n ȭ�鿡 + ǥ�ð� ��Ÿ����, ���� ������ �����ϼ���. \n + ǥ�ð� ����� ������ ���ù��� �亯�� ���ּ���.\n\n �����ڰ� �غ�Ǿ����� �̹�¡�� �����մϴ�. (s)') ;
            DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color, [], [], [], 1.3);
            Screen('Flip', theWindow);
            
        end
    end
    
    %% For DISDAQ
    
    % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
    % 4 seconds: "�����մϴ�..."
    
    data.runscan_starttime = GetSecs; % run start timestamp
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('�����մϴ�...'), 'center', 'center', white, [], [], [], 1.2);
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
        waitsec_fromstarttime(data.biopac_starttime, 1);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    
    %% START FREE THINKING
    
    % 6 seconds for being ready
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(data.runscan_starttime, 16); % after 8 seconds of disdaq, 8 seconds of baseline
    
    data.freethinking_start_time{ft_num} = GetSecs;
    
    data = thought_sampling(data); % thought sampling tasks
    
    save(data.datafile, 'data', '-append');
    data.freethinking_end_time = GetSecs;
    
    while GetSecs - data.freethinking_end_time < 3
        run_end_msg = double('�̹� ������ �������ϴ�. \n ��Ÿ���� �����鿡 �亯���ּ���.') ;
        DrawFormattedText(theWindow, run_end_msg, 'center', 'center', text_color, [], [], [], 1.5);
        Screen('Flip', theWindow);
    end
    
    data = pico_post_run_survey_resting(data);
    save(data.datafile, 'data', '-append');
    
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    run_END_msg = '���ϼ̽��ϴ�. ��� ����� �ּ���.';
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, double(run_END_msg), 'center', textH, white);
    Screen('Flip', theWindow);
    
    if USE_EYELINK
        Eyelink('Message','Story Run END');
        eyelink_main(edfFile, 'Shutdown');
    end
    if USE_BIOPAC
        data.biopac_endtime = GetSecs; % biopac timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        if ft_num == 1
            ending_trigger = 0.1;
        else
            ending_trigger = 0.7;
        end
        waitsec_fromstarttime(data.biopac_endtime, ending_trigger); % BIOPAC TRIGGER for FT run = 0.1, 0.7
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


function data = thought_sampling(data)

global theWindow W H; % window property
global fontsize window_rect text_color textH % lb tb recsize barsize rec; % rating scale

fixation_point = double('+') ;
Screen('TextSize', theWindow, fontsize(3));
DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
Screen('Flip', theWindow);

resting_sTime = GetSecs;
data.FTfunction.fixation_start_time = resting_sTime;

rng('shuffle')

% % % edit
% sampling_time = [5] ;
% resting_total_time = 10;

base_time = 55:55:14*60-55;
sampling_time = base_time + randi(10,1,14) - 5;
resting_total_time = 14*60;

% sampling_time = [60 120 180 240 300] + randi(10,1,5) - 5;
% resting_total_time = 360;
%
data.FTfunction.sampling_time = sampling_time;

while GetSecs - resting_sTime < resting_total_time
    for i = 1:numel(sampling_time)
        k = 0;
        while GetSecs - resting_sTime > (sampling_time(i) - 2.5) && GetSecs - resting_sTime < (sampling_time(i) + 2.5)
            k = k +1;
            if k == 1
                data.FTfunction.start_Sampling{i} = GetSecs;
            end
            data.FTfunction.end_Sampling{i} = GetSecs;
            Screen('TextSize', theWindow, fontsize(3));
            FT_msg = double('���� ���� ������ �ϰ� �ִ��� \n�ܾ ���� �����ּ���.') ;
            DrawFormattedText(theWindow, FT_msg, 'center', 'center', text_color, [], [], [], 1.5);
            Screen('Flip', theWindow);
        end
        Screen('TextSize', theWindow, fontsize(3));
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        
        if i == 7 % when 7th trial is done, save taskdata
            save(data.datafile, 'data', '-append');
        end
        
    end
end

data.FTfunction.fixation_end_time = GetSecs;

% last trial
while GetSecs - data.FTfunction.fixation_end_time <5
    
    k = k +1;
    if k == 1
        data.FTfunction.start_Sampling{i+1} = GetSecs;
    end
    data.FTfunction.end_Sampling{i+1} = GetSecs;
    
    end_msg = double('���� ���� ������ �ϰ� �ִ��� \n�ܾ ���� �����ּ���.') ;
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color, [], [], [], 1.5);
    Screen('Flip', theWindow);
    
end

data.FTfunction.last_sampling_end_time = GetSecs;


% after last trial, wait for 15 seconds

while GetSecs - data.FTfunction.last_sampling_end_time < 15
    
    Screen('TextSize', theWindow, fontsize(3));
    DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
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

function data = pico_post_run_survey_resting(data)

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
    lb,tb+2*recsize(2); lb+recsize(1),tb+2*recsize(2)]; %6�� �簢���� ���� �� �������� ��ǥ

% trajectory = [];
% trajectory_time = [];
%
% j = 0;
post_run.start_time = GetSecs;
question_type = {'Valence','Self-relevance','Time','Vividness','Safe&Threat'};

% save(data.datafile, 'data', '-append');

Screen(theWindow, 'FillRect', bgcolor, window_rect);
intro_prompt1 = double('��� ���� ���� ������ �ϴµ��� �ڿ������� ���ø� ������ ���� �����Դϴ�.') ;
Screen('TextSize', theWindow, fontsize(2));
DrawFormattedText(theWindow, intro_prompt1,'center', H/5-80, white);

title={'','', '','', '', '';
    '����', '���� ����\n������ ����', '����', '���� �������� ����', '����', '';
    '�߸�', '', '����', '', '�߸�', '';
    '����','���� ������\n�ſ� ����', '�̷�','�ſ� ������','����','';
    '�������� ����', '�ڽŰ� ������ �ִ� ����', '���� ������ �ִ� �ڽ��� �ð�', ...
    '� ��Ȳ�̳� �����\n�󸶳� �����ϰ� ���ø��� �ϴ���', '���� �Ǵ� ������\n�ǹ��ϰų� ������ �ϴ���', '';
    '�� ������ ����Ų ������?', '�� ������ ���� ������ �ִ� ������?', '�� ������ ���� ������ �ִ� �ڽ��� �ð�?', ...
    '�� ������ � ��Ȳ�̳� �����\n�����ϰ� ���ø��� �߳���?', '�� ������ ���� �Ǵ� ������\n�ǹ��ϰų� ������ �߳���?',''};


rng('shuffle');
z = randperm(6);
barsize = barsizeO(:,z);
title = title(:,z);


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

data.postrunQ = post_run ;

save(data.datafile, 'data', '-append');

end


function data = pico_post_run_survey_resting_old(data, varargin)

global theWindow W H; % window property
global white red orange blue bgcolor tb ; % color
global fontsize window_rect text_color
tb = H/5;
question_type = {'Valence','Self','Time','Vividness','Safe&Threat'};

for i = 1:5
    rating{1,i} = question_type{i};
end

save(data.datafile, 'data', '-append');

% QUESTION
title={'��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ ����Ų ������ �����ΰ���?',...
    '��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ ���� ������ �ִ� ������ ��� �����ΰ���?',...
    '��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ ���� ������ �ִ� �ڽ��� �ð��� �����ΰ���?', ...
    '��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ � ��Ȳ�̳� ����� �����ϰ� ���ø��� �߳���?',...
    '��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ ���� �Ǵ� ������ �ǹ��ϰų� ������ �߳���?',...
    '��� ���� ���� ������ �ϴ� ���� �ڿ������� ���ø� ������ ���� �����Դϴ�.\n\n�� ������ ��� ������ �ܾ�� ���õ� �����̾�����?';
    '����', '���� ����\n������ ����', '����', '���� �������� ����', '����', '���� ���� ����';
    '�߸�', '', '����', '', '�߸�', '';
    '����','���� ������\n�ſ� ����', '�̷�','�ſ� ������','����','�ſ� ���� ����'};

linexy1 = [W/4 W*3/4 W/4 W/4 W/2 W/2 W*3/4 W*3/4;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7 H/2-7 H/2+7];
linexy2 = [W*3/8 W*5/8 W*3/8 W*3/8 W*5/8 W*5/8;
    H/2 H/2 H/2-7 H/2+7 H/2-7 H/2+7];
rng('shuffle');
z = randperm(5);


for i = 1:(numel(title(1,:))-1)
    if mod(z(i),2) % odd number, valence, time, safe&threat
        question_start = GetSecs;
        SetMouse(W/2, H/2);
        
        while(1)
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;
            y = H/2;
            if x < W/4, x = W/4;
            elseif x > W*3/4, x = W*3/4;
            end
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            Screen('DrawLines',theWindow, linexy1, 3, 255);
            DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
            DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
            DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
            DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
            
            Screen('DrawDots', theWindow, [x;y], 12, orange, [0 0], 1); % check size
            Screen('Flip', theWindow);
            
            if GetSecs - question_start >= 5
                button(1) = true;
            end
            
            if button(1)
                rating{2,z(i)} = (x-W/2)/(W/4);
                rating{3,z(i)} = GetSecs-question_start;
                rrtt = GetSecs;
                
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('DrawLines',theWindow, linexy1, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,1)-15, linexy1(2,1)+20, linexy1(1,1)+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy1(2,1)+20, W/2+20, linexy1(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy1(1,2)-15, linexy1(2,1)+20, linexy1(1,2)+20, linexy1(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x,y], 9, red, [0 0], 1);
                Screen('Flip', theWindow);
                %                     if USE_EYELINK
                %                         Eyelink('Message','Rest Question response');
                %                     end
                waitsec_fromstarttime(question_start, 5);
                rating{4,z(i)} = GetSecs;
                WaitSecs(0.5)
                break;
            end
        end
        
    else   % even number, self-relevance, vividness
        question_start = GetSecs;
        SetMouse(W*3/8, H/2);
        
        while(1)
            % Track Mouse coordinate
            [mx, ~, button] = GetMouse(theWindow);
            
            x = mx;
            y = H/2;
            if x < W*3/8, x = W*3/8;
            elseif x > W*5/8, x = W*5/8;
            end
            
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            Screen('DrawLines',theWindow, linexy2, 3, 255);
            DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
            
            DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
            DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
            DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
            
            Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
            Screen('Flip', theWindow);
            
            if GetSecs - question_start >= 5
                button(1) = true;
            end
            if button(1)
                rating{2,z(i)} = (x-W*3/8)/(W/4);
                rating{3,z(i)} = GetSecs-question_start;
                rrtt = GetSecs;
                
                Screen(theWindow, 'FillRect', bgcolor, window_rect);
                Screen('DrawLines',theWindow, linexy2, 3, 255);
                DrawFormattedText(theWindow, double(title{1,z(i)}), 'center', tb, white, [], [], [], 1.5);
                
                DrawFormattedText(theWindow, double(title{2,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,1)-15, linexy2(2,1)+20, linexy2(1,1)+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{3,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [W/2-15, linexy2(2,1)+20, W/2+20, linexy2(2,1)+80]);
                DrawFormattedText(theWindow, double(title{4,z(i)}),'center', 'center', white, [],[],[],[],[],...
                    [linexy2(1,2)-15, linexy2(2,1)+20, linexy2(1,2)+20, linexy2(2,1)+80]);
                
                Screen('DrawDots', theWindow, [x;y], 9, red, [0 0], 1);
                Screen('Flip', theWindow);
                %                     if USE_EYELINK
                %                         Eyelink('Message','Rest Question response');
                %                     end
                waitsec_fromstarttime(question_start, 5);
                rating{4,z(i)} = GetSecs;
                WaitSecs(0.5)
                break;
            end
        end
    end
end
WaitSecs(.1);

data.rating = rating ;

save(data.datafile, 'data', '-append');

end
