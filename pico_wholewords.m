function [words, sid] = pico_wholewords(basedir)
%%
datdir = fullfile(basedir, 'data') ;
sid = input('Subject ID? (e.g., coco001_khj): ', 's');
subject_dir = filenames(fullfile(datdir, [sid '*']), 'char');
[~, sid] = fileparts(subject_dir);
sid = sid(1:7);

dat_file{1} = fullfile(subject_dir, ['THOUGHT_SAMPLING_' sid '_run1.mat']);
dat_file{2} = fullfile(subject_dir, ['THOUGHT_SAMPLING_' sid '_run2.mat']);
dat_file{3} = fullfile(subject_dir, ['THOUGHT_SAMPLING_' sid '_run3.mat']);

data = cell(3, 15);
%
for i=1:3
    load(dat_file{i});
    data(i,:)=response;
end

words = data;
words

end



