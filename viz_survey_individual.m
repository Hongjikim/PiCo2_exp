
clf; clear dat_all new_dat

basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');

list = {'coco006_psj', 'coco008_kjw', 'coco010_khb', 'coco011_lada'};

load colormap_wani.mat
cols = cols_14_wani([1, 5, 10, 12],:);

for sub = 1:4
    
    subject_codes{1} = list{sub};
    
    count = 0;
    for sub_num = 1
        clear sub_dir; sub_dir = filenames(fullfile(datdir, subject_codes{sub_num}), 'char');
        clear survey_files; survey_files = filenames(fullfile(sub_dir, '*survey*run*.mat'));
        for run = 1:numel(survey_files)
            count = count+1;
            clear survey; load(survey_files{run});
            for dims_i = 1:numel(survey.dat.response)
                dat_all{dims_i}(count,:) = survey.dat.response{dims_i}(run,:);
            end
        end
    end
    
    clear new_dat
    for i = 1:numel(dat_all)
        new_dat(i,:) = dat_all{i}(:)';
    end
    
    subplot(2,2, sub)
    scatter(new_dat(13,:)', new_dat(14,:)', [], cols(sub,:), 'filled'); lsline;
    set(gcf, 'color', 'white');
end
