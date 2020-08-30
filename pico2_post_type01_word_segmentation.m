function pico2_post_type01_word_segmentation(basedir, sid)

%%
datdir = fullfile(basedir, 'data');
subject_dir = filenames(fullfile(datdir, [sid, '*']), 'char');

fname_words = filenames(fullfile(subject_dir, ['WORDS_*.mat']));

load(fullfile(basedir, 'promt_kor3_event_seg.mat'));

data = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    if numel(response) == 15
        data(r,:)=response;
    end
end

words = data;

savename = fullfile(subject_dir, ['Post_rating01_word_seg_', sid, '.mat']);

for run_num = numel(fname_words)
    
    % To-Do
    % display "this is nth runs"
    % for loop for 4 runs
    
    start = false;
    
    clear target_run_words
    target_run_words = words(run_num,:);
    
    all_add = []; clear temp_list
    count = 0 ;
    
    while ~start
        count = count + 1;
        if count == 1, string(target_run_words), end
        clc; clear add_or_delete;
        add_or_delete = input(input_msg.a, 's');
        [(1:numel(target_run_words))', string(target_run_words')]
        if strcmp(add_or_delete, 'a') % add
            target_add = input(input_msg.c);
            all_add = sort([all_add target_add]);
        elseif strcmp(add_or_delete, 'd') % delete
            target_del = input(input_msg.c);
            all_add(find(all_add==target_del)) = [];
            
        elseif strcmp(add_or_delete, 'z') % delete
            break;
        else % neither a or d, error
            clc; add_or_delete = input(input_msg.b, 's');
            if strcmp(add_or_delete, 'a') % add
                target_add = input(input_msg.c, 's');
                all_add = sort([all_add target_add]);
                
            elseif strcmp(add_or_delete, 'd') % delete
                target_del = input(input_msg.c, 's');
                all_add(find(all_add==target_del)) = [];
                
            elseif strcmp(add_or_delete, 'z') % delete
                break; start = true;
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
    save(savename, 'seg_result')

end

save(savename, 'seg_result')


