function [words, sid] = pico2_wholewords(basedir)
%%
datdir = fullfile(basedir, 'data') ;
sid = input('Subject ID? (e.g., coco001_khj): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

fname_words = filenames(fullfile(subject_dir, ['WORDS_*.mat']));

data = cell(size(fname_words,1), 15);

for r = 1:size(fname_words,1)
    load(fname_words{r});
    data(r,:)=response;
end

words = data;
words

end



