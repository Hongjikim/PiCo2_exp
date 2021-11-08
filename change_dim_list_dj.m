%% change wrong dim list in post-type2 data

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
 
for sub_i = 2:10 % 1:26
    clear sub_dir;
    sub_dir = filenames(fullfile(datdir, ['coco0', num2str(sub_i, '%.2d'), '*']), 'char');
    
    survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    for run = 1:numel(survey_files)
        clear survey;
        load(survey_files{run});
        survey.dat.whole_dims.name = new_dim.name;
        [~, msg, ~] = fileparts(survey.surveyfile);
        save(fullfile(sub_dir, msg), 'survey');
        disp(msg)
    end
end

%% show difference

orig_file = 'Post_rating02_19_dims_coco011_ldh_run03.mat';
edited_file = 'Post_rating02_19_dims_coco011_ldh_run03_after.mat';

dims.name = {'자기관련도','중요도', '중심성', '관계성', '과거', '현재', '미래',  ...
    '빈도', '긍정', '부정', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', ...
    '추상성/관념성', '자발성', '목표'};

dat1 = load(orig_file);
dat2 = load(edited_file);

for i = 1:19
    dat2.survey.dat.whole_dims.name{i} = dims.name{i};
end

save edited_file


run_num = 3;



for dim = 1:19
    check(dim,1) = sum(dat1.survey.dat.response{dim}(run_num,:) ~= dat2.survey.dat.response{dim}(run_num,:));
end

find(check~=0)

[dat1.survey.dat.response{5}(run_num,:)' dat2.survey.dat.response{5}(run_num,:)']
