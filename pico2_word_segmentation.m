function pico2_word_segmentation(basedir, sid)

%%
datdir = fullfile(basedir, 'data');
subject_dir = filenames(fullfile(datdir, [sid, '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

run_num = input('Run number for word segmentation? (1, 2, 3, 4): ');
fname_words = filenames(fullfile(subject_dir, ['WORDS_*.mat']));

data = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    if numel(response) == 15
        data(r,:)=response;
    end
end

words = data;

target_run_words = words(run_num,:);

all_add = []; clear temp_list
count = 0 ;
while true
    count = count + 1;
    if count == 1, string(target_run_words), end
    clc; clear add_or_delete;
    add_or_delete = input('** 구분선을 더하고 싶으면 a를, 빼고 싶으면 d를 눌러주세요. (끝내고 싶을 땐 z를 눌러주세요.):', 's');
    [(1:numel(target_run_words))', string(target_run_words')]
    if strcmp(add_or_delete, 'a') % add
        target_add = input('** 몇 번째 단어 뒤에 구분선을 더하고 싶으신가요?(1-15): ');
        all_add = sort([all_add target_add]);
    elseif strcmp(add_or_delete, 'd') % delete
        target_del = input('** 몇 번째 단어 뒤의 구분선을 빼고 싶으신가요?(1-15): ');
        all_add(find(all_add==target_del)) = [];
        
    elseif strcmp(add_or_delete, 'z') % delete
        break;
    else % neither a or d, error
        clc; add_or_delete = input('** 잘못 누르신 것 같아요. 구분선을 더하고 싶으면 a를, 빼고 싶으면 d를 눌러주세요:', 's');
        if strcmp(add_or_delete, 'a') % add
            target_add = input('** 몇 번째 단어 뒤에 구분선을 더하고 싶으신가요?: (1-15)', 's');
            all_add = sort([all_add target_add]);
            
        elseif strcmp(add_or_delete, 'd') % delete
            target_del = input('** 몇 번째 단어 뒤의 구분선을 빼고 싶으신가요?: (1-15)', 's');
            all_add(find(all_add==target_del)) = [];
            
        elseif strcmp(add_or_delete, 'z') % delete
            break;
        end
    end
    
    % display current word list
    if numel(all_add) == 0
        temp_list = target_run_words(1:end);
    elseif numel(all_add) == 1
        temp_list = [target_run_words(1:all_add), '/', target_run_words(all_add+1:end)];
    else
        for i = 1:numel(all_add)
            if i == 1
                temp_list = [target_run_words(1:all_add(i)), '/'];
            elseif i == numel(all_add)
                temp_list = [temp_list, target_run_words(all_add(i-1)+1:all_add(i)), ...
                    '/', target_run_words(all_add(i)+1:end)];
            else
                temp_list = [temp_list, target_run_words(all_add(i-1)+1:all_add(i)), '/'];
            end
        end
    end
    string(temp_list)
end

seg_result = temp_list;
savename = fullfile(subject_dir, ['Word_Segmentation_run', num2str(run_num), '.mat']);

save(savename, 'seg_result')
