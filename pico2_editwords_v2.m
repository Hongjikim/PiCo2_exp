function words = pico2_editwords(basedir, sid)
%%
datdir = fullfile(basedir, 'data');
subject_dir = filenames(fullfile(datdir, [sid, '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

run_num = input('which run do you want to edit? (1, 2, 3, 4): ');
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

while true
    [(1:numel(target_run_words))', string(target_run_words')]
    edit_num = input('which word do you want to edit? (1-15 / e (end)): ', 's');
    if ~strcmp(edit_num, 'e')
        clear new_word
        new_word = input(['what is the correct word for ' char((target_run_words(str2num(edit_num)))) ' ?: '], 's');
        target_run_words{str2num(edit_num)} = new_word;
    else
        break
    end
end

response = target_run_words;
save(fname_words{run_num}, 'response')

data = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    if numel(response) == 15
        data(r,:)=response;
    end
end

words = data;

