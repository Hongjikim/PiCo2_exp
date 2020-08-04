clear;

global theWindow words center_X center_Y white Xgap Ygap y_len

% msg
practice_prompt{1} = double('a');
practice_prompt{2} = double('bb');
practice_prompt{3} = double('cc');

words = {'눈물', '학대', '거울'};
dims = {'자기 관련도', '긍정', '부정', '중요도', '관계성', '중심성', '과거', '현재', '미래', ...
    '빈도', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', '추상정/관념성', ...
    '자발성', '목표'};

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];
%
bgcolor = 100;

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]/1.4 ; %

W = window_rect(3); % width of screen
H = window_rect(4); % height of screen

% screenCenterX = window_rect(3)/2;
% screenCenterY = window_rect(4)/2;

theWindow = Screen('OpenWindow', 0, bgcolor, window_rect);

% Screen('DrawDots', theWindow, [screenCenterX;screenCenterY], 6, [0, 0, 0], [0 0], 1);
Screen('Flip', theWindow);

font = 'Arial';
fontsize = 35;

Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);

% HideCursor;

% Screen('DrawText', theWindow, 'helloworld', [window_rect(3)/2], [window_rect(4)/2], [0 0 0], 100)

row = 4; column = 5;

Xgap = W/(column*2+2);
Ygap = H/(row*2+2);

y_len = 0.75; % half length of vertical lines

% draw vertical lines and display target word


for r = 1:row % row
    for c = 1:column % column
        % get center of each cell
        center_X(r,c) = Xgap * (2*c);
        center_Y(r,c) = Ygap * (2*r);
    end
end

for r_response = 1:row % row
    for c_response = 1:column % column
        
        button = [];
        
        SetMouse(center_X(r_response,c_response), center_Y(r_response,c_response));
        
        while ~any(button)
            
            draw_horizontal_lines(row,column);
            
            %             Screen('Flip', theWindow);
            
            
            if r_response == 1 && c_response == 1 % first cell: target word
                break
            else
                
                [mx, my, button] = GetMouse(theWindow);
                
                x = center_X(r_response,c_response) + Xgap/2; % fix x coordinate (don't move)
                y = my;
                
                % prevent moving outside of the cell
                if y > center_Y(r_response,c_response) + Ygap*y_len
                    y = center_Y(r_response,c_response) + Ygap*y_len; SetMouse(x,y);
                elseif y < center_Y(r_response,c_response) - Ygap*y_len
                    y = center_Y(r_response,c_response) - Ygap*y_len; SetMouse(x,y);
                end
                
                Screen('DrawDots', theWindow, [x;y], 9, orange, [0 0], 1);
                
            end
            
            Screen('Flip', theWindow);
            
            if any(button)
                draw_horizontal_lines(row,column);
                Screen('DrawDots', theWindow, [x;y], 12, red, [0 0], 1);
                Screen('Flip', theWindow);
                WaitSecs(0.5)
                break
            end
        end
    end
end




%
%
% frameDuration = Screen('GetFlipInterval', theWindow);
% fliptime = Screen('Flip', theWindow);

function draw_horizontal_lines(row,column)

global theWindow words center_X center_Y white Xgap Ygap y_len

for r = 1:row % row
    for c = 1:column % column
        % get center of each cell
        
        if r == 1 && c == 1 % first cell: target word
            DrawFormattedText(theWindow, double(words{1}), center_X(r,c), center_Y(r,c), white);
            
        else
            line_coordinate = [center_X(r,c) + Xgap/2, center_X(r,c) + Xgap/2; center_Y(r,c) + Ygap*y_len, center_Y(r,c) - Ygap*y_len];
            
            Screen('DrawLines', theWindow, line_coordinate, 3, white, [0 0]);
        end
        
    end
    
end
end