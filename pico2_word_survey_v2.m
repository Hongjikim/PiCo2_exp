function survey = pico2_word_survey_v2(basedir, sid, words, varargin)
%% default setting

datdir = fullfile(basedir, 'data') ;
% sid = input('Subject ID? (e.g., coco001_khj): ', 's');
subject_dir = filenames(fullfile(datdir, sid), 'char');
[~, sid] = fileparts(subject_dir);

testmode = false;
practice_mode = false;
savedir = subject_dir;

rng('shuffle');

%% CREATE AND SAVE DATA

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

survey.subject = sid;
survey.surveyfile = fullfile(savedir, [subjdate, '_surveydata_' sid '.mat']);
survey.version = 'PICO2_v1_08-2020_Cocoanlab';
survey.starttime = datestr(clock, 0);
survey.starttime_getsecs = GetSecs;

if exist(survey.surveyfile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', [subjdate, '_surveydata_' sid '.mat']);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        copy_fname = fullfile(savedir, ['surveydata_sub' sid '_copy.mat']);
        copyfile(survey.surveyfile, copy_fname);
        save(survey.surveyfile, 'survey');
    end
else
    save(survey.surveyfile, 'survey');
end

survey.dat.whole_words = words;

%% PARSING OUT OPTIONAL INPUT
magic_keyboard = false;
start_run = 1;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'practice'}
                practice_mode = true;
            case {'test', 'testmode'}
                testmode = true;
            case {'savedir'}
                savedir = varargin{i+1};
            case {'mgkey'}
                magic_keyboard = true;
            case {'run_number'}
                start_run = varagin{i+1};
        end
    end
end

%% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb bodymap recsize barsize rec; % rating scale
global center_X center_Y Xgap Ygap y_len

bgcolor = 100;

font = 'NanumBarunGothic';
fontsize = [25 35];

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];

dims = {'자기 관련도', '긍정', '부정', '중요도', '관계성', '중심성', '과거', '현재', '미래', ...
    '빈도', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', '추상정/관념성', ...
    '자발성', '목표'};

survey.dat.whole_dims = dims;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/1.3 ; %

W = window_rect(3); % width of screen
H = window_rect(4); % height of screen

theWindow = Screen('OpenWindow', 0, bgcolor, window_rect);

Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize(2));

% HideCursor;

row = 3; column = 5;

Xgap = W/(column*2+2);
Ygap = H/(row*2+2);

y_len = 0.75; % half length of vertical lines

% draw vertical lines and display target word


for r = 1:row % row
    for c = 1:column % column
        % get center of each cell
        center_X(r,c) = Xgap * (2*c);
        center_Y(r,c) = Ygap * (2*r+1) - Ygap/4;
    end
end

dim_order = randperm(numel(dims));
survey.dat.dim_order = dim_order;
for run_i = start_run:1% size(words,1)
    
    temp_words = words(run_i,:);
    
    for page_num = 1% numel(dims)
        
        word_count = 0; 
        
        if run_i == 1
            survey.dat.response{dim_order(page_num)} = nan(size(words));
        end
        
        target_dim = dims{dim_order(page_num)};
        
        survey.dat.dim_type{dim_order(page_num)} = target_dim;
        
        for r_response = 1:row % row
            for c_response = 1:column % column
                
                word_count = word_count + 1; 
                button = [];
                
                SetMouse(center_X(r_response,c_response), center_Y(r_response,c_response));
                
                while ~any(button)
                    
                    draw_horizontal_lines(row,column, temp_words, target_dim);
                    
                    [~, y, button] = GetMouse(theWindow);
                    
                    x = center_X(r_response,c_response) - Xgap/2; % fix x coordinate (don't move)
                    
                    % prevent moving outside of the cell
                    if y > center_Y(r_response,c_response) + Ygap*y_len
                        y = center_Y(r_response,c_response) + Ygap*y_len; SetMouse(x,y);
                    elseif y < center_Y(r_response,c_response) - Ygap*y_len
                        y = center_Y(r_response,c_response) - Ygap*y_len; SetMouse(x,y);
                    end
                    
                    Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
                    
                    Screen('Flip', theWindow);
                    
%                     % if press 'b', go back one trial
%                     if magic_keyboard
%                         [~,~,keyCode]=PsychHID('KbCheck', 3);
%                     else
%                         [~,~,keyCode] = KbCheck;
%                     end
%                     
%                     if keyCode(KbName('b'))==1
%                         if c_response ~= 1
%                             c_response = c_response - 1;
%                         else % c_response == 1, r_response ~= 1
%                             c_response = column; r_response = r_response - 1;     
%                         end
%                         word_count = word_count - 1;
%                         
%                         draw_horizontal_lines(row,column, temp_words, target_dim);
%                         Screen('Flip', theWindow);
%                         WaitSecs(0.5);
%                         break
%                     end
                    
                    if any(button)
                        draw_horizontal_lines(row,column, temp_words, target_dim);
                        Screen('DrawDots', theWindow, [x;y], 12, red, [0 0], 1);
                        Screen('Flip', theWindow);
                        
                        survey.dat.response{dim_order(page_num)}(run_i, word_count) = (center_Y(r_response,c_response)-y)/(Ygap*y_len*2);
                        
                        WaitSecs(0.5);
                        break
                    end
                end
            end
        end
        save(survey.surveyfile, 'survey');
    end
    save(survey.surveyfile, 'survey');
end
save(survey.surveyfile, 'survey');


%
%
% frameDuration = Screen('GetFlipInterval', theWindow);
% fliptime = Screen('Flip', theWindow);

    function draw_horizontal_lines(row,column, temp_words, target_dim)
        
        %         global words center_X center_Y white Xgap Ygap y_len
        
        wc = 0; % word count
        
        for r = 1:row % row
            for c = 1:column % column
                
                wc = wc + 1;
                % display 15 target words
                
                Screen('TextSize', theWindow, fontsize(1))
                clear new_word new_word_temp
                if numel(temp_words{wc}) > 5
                    if contains(temp_words{wc}, ' ')
                        new_word_temp = char(split(temp_words{wc}, ' '));
                        new_word = [new_word_temp(1,:) '\n' deblank(new_word_temp(2,:))];
                    else % no space
                        new_word_temp(1,:) = temp_words{wc}(1:ceil(numel(temp_words{wc})/2));
                        new_word_temp(2,:) = temp_words{wc}(ceil(numel(temp_words{wc})/2)+1:end);
                        new_word = [new_word_temp(1,:) '\n' deblank(new_word_temp(2,:))];
                    end
                    DrawFormattedText(theWindow, double(new_word), center_X(r,c)-Xgap/4, center_Y(r,c), white);                    
                else
                    DrawFormattedText(theWindow, double(temp_words{wc}), center_X(r,c)-Xgap/4, center_Y(r,c), white);
                end
                
                % draw horizontal lines
                line_coordinate = [center_X(r,c) - Xgap/2, center_X(r,c) - Xgap/2; center_Y(r,c) + Ygap*y_len, center_Y(r,c) - Ygap*y_len];
                Screen('DrawLines', theWindow, line_coordinate, 3, white, [0 0]);
                
            end
            
        end
        
        % display target dimension name
        Screen('TextSize', theWindow, fontsize(2))
        DrawFormattedText(theWindow, double(target_dim), 'center', Ygap, white);
        
    end
end
