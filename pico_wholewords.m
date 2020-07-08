function [words, sid] = pico_wholewords(basedir)
%%
datdir = fullfile(basedir, 'data') ;
sid = input('Subject ID? (e.g., coco001_khj): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

for rr = 1:size(filenames(fullfile(subject_dir, 'THOUGHT*mat')),1)
    dat_file{rr} = fullfile(subject_dir, ['THOUGHT_SAMPLING_' sid '_run', num2str(rr), '.mat']);
end

data = cell(size(filenames(fullfile(subject_dir, 'THOUGHT*mat')),1), 15);
%
for i=1:size(filenames(fullfile(subject_dir, 'THOUGHT*mat')),1)
    load(dat_file{i});
    data(i,:)=response;
end

words = data;
words

end



