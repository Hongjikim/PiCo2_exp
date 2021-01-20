%% change wrong dim list in post-type2 data

datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';

for sub_i = 11 % 1:26
    clear sub_dir;
    sub_dir = filenames(fullfile(datdir, ['coco0', num2str(sub_i, '%.2d'), '*']), 'char');
    
    survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    for run = 1:numel(survey_files)
        clear survey;
        load(survey_files{run});
        survey.dat.whole_dims.name = new_dim.name;
        [~, msg, ~] = fileparts(survey.surveyfile);
%         msg = 'Post_rating02_19_dims_coco001_hjw_run4.mat';
        save(fullfile(sub_dir, msg), 'survey');
        disp(msg)
    end
end

%% show difference

orig_file = 'Post_rating02_19_dims_coco012_lme_run03.mat';
edited_file = 'Post_rating02_19_dims_coco012_lme_run03_after.mat';

run_num = 3;

dat1 = load(orig_file);
dat2 = load(edited_file);

for dim = 1:19
    check(dim,1) = sum(dat1.survey.dat.response{dim}(run_num,:) ~= dat2.survey.dat.response{dim}(run_num,:));
end

find(check~=0)

dd = 5;
[dat1.survey.dat.response{dd}(run_num,:)' dat2.survey.dat.response{dd}(run_num,:)']
