function pico2_post_type01_word_segmentation(basedir, sid)

%%

clc; 

load(fullfile(basedir, 'promt_kor3_event_seg.mat'));

datdir = fullfile(basedir, 'data');
subject_dir = filenames(fullfile(datdir, [sid, '*']), 'char');

% run_num = input(input_msg.run_num);

fname_words = filenames(fullfile(subject_dir, ['WORDS_*.mat']));


data = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    if numel(response) == 15
        data(r,:)=response;
    end
end

words = data;

savename = fullfile(subject_dir, ['Post_rating01_word_seg_', sid, '.mat']);

% run_count = 0;

for run_num = 1:numel(fname_words)
    
    clc; 
    
%     run_count = run_count + 1;
    
    clear target_run_words
    target_run_words = words(run_num,:);
    
    all_add = []; clear temp_list
    count = 0 ;
    
    while true
        
        count = count + 1;
        if count == 1
            disp([num2str(run_num) input_msg.d])
            string(target_run_words)
        else
            clc;
        end
        
        clear add_or_delete;
        add_or_delete = input(input_msg.a, 's');
        
        [(1:numel(target_run_words))', string(target_run_words')]
        
        if strcmp(add_or_delete, 'a') % add
            target_add = input(input_msg.c);
            all_add = sort([all_add target_add]);
        elseif strcmp(add_or_delete, 'd') % delete
            target_del = input(input_msg.e);
            all_add(find(all_add==target_del)) = [];
        elseif strcmp(add_or_delete, 'z') % end
            break
%             if run_count ~= numel(fname_words)
%                 return;
%             else
%                 break
%             end
        else % neither a or d, error
            clc; add_or_delete = input(input_msg.b, 's');
            if strcmp(add_or_delete, 'a') % add
                target_add = input(input_msg.c, 's');
                all_add = sort([all_add target_add]);
                
            elseif strcmp(add_or_delete, 'd') % delete
                target_del = input(input_msg.e, 's');
                all_add(find(all_add==target_del)) = [];
                
            elseif strcmp(add_or_delete, 'z') % end
                break
%                 if run_count ~= numel(fname_words)
%                     return;
%                 else
%                     break
%                 end
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
    
    seg_result{run_num} = temp_list;
    save(savename, 'seg_result')

end

save(savename, 'seg_result')


