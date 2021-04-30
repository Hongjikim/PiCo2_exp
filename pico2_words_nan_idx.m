function pico2_words_nan_idx(basedir, sid)

%% manual input of nan idx
% 0: not a NaN (a word)
% 1: NaN ('없음', the participant reported 'no idea')
% 2: NaN ('X', the participant didn't report or we missed the word)

clc;

load(fullfile(basedir, 'prompt_kor4_nan_idx.mat'));

datdir = fullfile(basedir, 'data');
subject_dir = filenames(fullfile(datdir, [sid, '*']), 'char');

fname_words = filenames(fullfile(subject_dir, ['WORDS_*.mat']));

data = cell(15, size(fname_words,1)); % for words

for r = 1:size(fname_words,1)
    load(fname_words{r});
    if numel(response) == 15
        data(:,r)=response;
    end
end

words = data;

savename = fullfile(subject_dir, ['word_nan_idx_', sid, '.mat']);

nan_idx = zeros(size(words)); % 0: not-nan, 1: 없음, 2: X

number_cell = cell(15,1);
for i = 1:15, number_cell{i} = num2str(i); end

for run_num = 1:4
    
    clc;
    
    clear target_run_words
    target_run_words = words(:,run_num);
        
    while true
        
        clc;
        disp([['#'; number_cell] [['run', num2str(run_num)]; target_run_words]])
        go_or_nogo = input(input_msg.a, 's');
        
        if strcmp(go_or_nogo, 'z') % input = z, done
            break; % finish
        else
            target_num = str2num(go_or_nogo);
            nan_idx(target_num, run_num) = 1; % 1: 'no idea'
        end
        
    end
    
    while true
        
        clc;
        disp([['#'; number_cell] [['run', num2str(run_num)]; target_run_words]])
        go_or_nogo = input(input_msg.b, 's');
        
        if strcmp(go_or_nogo, 'z') % input = z, done
            break; % finish
        else
            target_num = str2num(go_or_nogo);
            nan_idx(target_num, run_num) = 2; % 1: 'no idea'
        end
        
    end
    
end

save(savename, 'nan_idx')
end


%% Korean prompt
% input_msg.a = '** "없음"에 해당하는 단어가 있으면 숫자를 눌러주세요. 다음으로 넘어가려면 z를 누르세요: ';
% input_msg.b = '** "X"에 해당하는 단어가 있으면 숫자를 눌러주세요. 다음으로 넘어가려면 z를 누르세요: ';
%
% save('prompt_kor4_nan_idx.mat', 'input_msg')
