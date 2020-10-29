%% while the participant is answering, please check the real-time answers

basedir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');
savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/check_type2/subject_wise';

for sub_i = [1:6, 8:14, 16:21]
    sub_dir = filenames(fullfile(datdir, ['coco', sprintf('%.3d',sub_i), '*']), 'char');


dims.name = {'self-relevance','importance/value', 'centrality', 'social', 'past', 'present', 'future',  ...
    'frequency', 'positive', 'negative', 'safe', 'threat', 'imagery', 'word', 'intensity', 'detail(vivid)', ...
    'abstract', 'spontaneous', 'deliberate(goal)'};

dims.msg = {'이 생각은 나와 관련이 있다.', '이 생각은 나에게 중요하다.', '이 생각은 나의 자아정체감에 핵심적이다', ...
    '이 생각은 다른 사람들과 관련이 있다.', '이 생각은 과거 시점과 관련이 있다.', '이 생각은 현재 시점과 관련이 있다.', ...
    '이 생각은 미래 시점과 관련이 있다.', '최근에 이 생각이 자주 들었다.', '이 생각에 대한 나의 감정은 긍정적이다.', ...
    '이 생각에 대한 나의 감정은 부정적이다.', '이 생각은 나에게 안전감을 준다.', '이 생각은 나에게 위협감을 준다.', ...
    '이 생각은 시각적 이미지로 떠오른다.', '이 생각은 글의 형태로 떠오른다.', '이 생각에 대한 나의 감정은..', ...
    '이 생각은 구체적이고 선명하다.', '이 생각은 추상적이고 관념적이다.', '이 생각은 자연스럽게 떠올랐다.', '이 생각은 특정 목표를 이루는 것과 관련이 있다.'};

mycolormap = [165,0,38; 215,48,39; 244,109,67; 253,174,97;
    254,224,144; 255,255,191; 224,243,248; 171,217,233;
    116,173,209; 69,117,180; 49,54,149]/255;
% mycolormap = cbrewer('div','Spectral',15);
mycolormap = flip(mycolormap);

% subject-wise result

clf; close all;

survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
for run = 1:numel(survey_files)
    clear survey; dat{run} = load(survey_files{run});
end

figure;

for run = 1:numel(survey_files)
    if sum(strcmp(fields(dat{run}.survey), 'dat')) == 1
        for i = 1:numel(dat{run}.survey.dat.response)
            if ~isempty(dat{run}.survey.dat.response{i})
                subplot(7,6,2*i-1), plot(dat{run}.survey.dat.response{i}(run,:));
                title(dims.name{i}, 'FontSize', 20); hold on; box off;
                %             ylim([-0.1, 1.1]);
                set(gcf, 'color', 'white');
                subplot(7,6,2*i), histogram(dat{run}.survey.dat.response{i}(run,:),30);
                set(gcf, 'units','normalized','outerposition',[0 0 1 1])
                title(dims.name{i}, 'FontSize', 20); hold on;
            end
        end
    end
end

saveas(gcf,fullfile(savedir, ["type2_whole_" + 'coco' + sprintf('%.3d',sub_i) + '.png']))
close all

end





%% group-wise result

clf;
% basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
basedir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subject_codes = subnames(1:19); % 1: numel(subnames)-# of extracted sub


count = 0;
for sub_num = 1:numel(subject_codes)
    clear sub_dir; sub_dir = filenames(fullfile(datdir, subject_codes{sub_num}), 'char');
    clear survey_files; survey_files = filenames(fullfile(sub_dir, '*rating02_19_dims*.mat'));
    
    for run = 1:numel(survey_files)
        clear survey; load(survey_files{run});
        for dims_i = 1:numel(survey.dat.response)
            dat_all{dims_i}(sub_num,15*(run-1)+1:15*run) = survey.dat.response{dims_i}(run,:);
        end
    end
end

close all;

for dim = 1:19
    subplot(7,6,2*dim-1), plot(dat_all{dim}');
    title(dims.name{dim}); hold on; box off;
    ylim([-0.1, 1.1]);
    set(gcf, 'color', 'white');
    set(gcf, 'units','normalized','outerposition',[0 0 1 1])
    subplot(7,6,2*dim), histogram(dat_all{dim},30);
    title(dims.name{dim}); hold on; 
end

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/check_type2/group_wise/check_graph';
saveas(gcf, fullfile(savedir, ["type2_group_wise_graphs" + '.png']))

%%

% histogram only
figure;
clf;
for dim = 1:19
    subplot(4,5,dim)
    histogram(dat_all{dim}, 30);
    set(gcf, 'color', 'white');
    set(gcf, 'units','normalized','outerposition',[0 0 1 1])
    title(dims.name{dim}, 'FontSize', 20); hold on;
end

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/check_type2/group_wise/check_graph';
saveas(gcf, fullfile(savedir, ["type2_group_wise_hists" + '.png']))

%% correlation imagesc
figure;
for dim = 1:19
    new_dat(dim,:) = dat_all{dim}(:)';
end

clf; imagesc(corr(new_dat')); colorbar;
set(gcf, 'units','centimeters','Position',[8 0 35 35])
set(gca, 'XTick', 1:19, 'XTickLabel', dims.name, 'FontSize', 15); xtickangle(30);
set(gca, 'YTick', 1:19, 'YTickLabel', dims.name, 'FontSize', 15); ytickangle(30);

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/check_type2/group_wise/heatmap';
saveas(gcf, fullfile(savedir, ["type2_group_wise_heatmap" + '.png']))
close all;

%% threshold with r and p values
[r, p] = corrcoef(new_dat');

figure;
temp = r.*(p < 0.05);
clf; imagesc(temp.*(r < -0.4 | r > 0.4)); colorbar;
set(gca, 'XTick', 1:19, 'XTickLabel', dims.name, 'FontSize', 15); xtickangle(30);
set(gca, 'YTick', 1:19, 'YTickLabel', dims.name, 'FontSize', 15); ytickangle(30);
set(gcf, 'units','centimeters','Position',[8 0 35 35])

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/check_type2/group_wise/heatmap';
title("threhold(p<0.05, |r|>0.4 heatmap");
saveas(gcf, fullfile(savedir, ["type2_thresholded_heatmap" + '.png']))
close all;

%% new heat map (within-subject)
subject_corr = [];

for sub_i = 1:19
    subplot(4,5,sub_i)
    for dim = 1:19
        subject_19dim{sub_i}(:,dim) = dat_all{dim}(sub_i,:)';
        subject_corr(:,:,sub_i) = corr(subject_19dim{sub_i});
%         imagesc(subject_corr); colorbar;
    end
end

for sub_i=1:19, subplot(4,5,sub_i), imagesc(subject_corr(:,:,sub_i)); colorbar; end
subplot(4,5,20)
imagesc(mean(subject_corr,3)), colorbar;

%%
newnew_dat = new_dat(1:3,:);
clf;
count = 0;
for d_one = 1:3% 19
    for d_two = 1:3%19
        count = count + 1;
        if d_one == d_two
            subplot(3,3, count);
            histogram(newnew_dat(d_one,:), 30)
        else
            subplot(3,3, count);
            clear r; r = corrcoef(newnew_dat(d_one,:), newnew_dat(d_two,:));
            scatter(newnew_dat(d_one,:), newnew_dat(d_two,:)); lsline;
            text(0.5, 0.5, num2str(r(1,2)))
        end
    end
end


%% Segmentation

figure;
sub006 = [1 1 1 1 1 1 1 1 1 2 1 1 1 1; 4 1 2 1 1 1 4 1 0 0 0 0 0 0; 2 2 1 3 1 1 2 1 1 1 0 0 0 0];
s6 = barh(sub006,'stacked');
mycolormap = cbrewer('div','Spectral',length(sub006));
for i = 1:length(sub006)
    s6(i).FaceColor = mycolormap(i,:);
end

figure;
sub008 = [4 1 1 1 3 1 1 1 1 1 0; 1 1 1 2 1 1 1 2 3 1 1; 7 2 2 1 1 2 0 0 0 0 0; 1 1 2 1 4 1 5 0 0 0 0];
s8 = barh(sub008, 'stacked');
mycolormap = cbrewer('div','Spectral', length(sub008));
for i = 1:length(sub008)
    s8(i).FaceColor = mycolormap(i,:);
end

figure;
sub010 = [1 3 3 4 3 1; 15 0 0 0 0 0; 10 1 2 1 1 0; 3 1 4 4 3 0];
s10 = barh(sub010, 'stacked');
mycolormap = cbrewer('div','Spectral', length(sub010));
for i = 1:length(sub010)
    s10(i).FaceColor = mycolormap(i,:);
end

figure;
sub011 = [1 2 3 7 2 0 0; 3 4 1 2 3 1 1; 1 5 1 2 4 2 0; 3 3 6 1 2 0 0];
s11 = barh(sub011, 'stacked');
mycolormap = cbrewer('div','Spectral', length(sub011));
for i = 1:length(sub011)
    s11(i).FaceColor = mycolormap(i,:);
end

%% type2 - individual result

clf;

survey_files = filenames(fullfile(pwd, '*survey*type2*.mat'));
for run = 1:numel(survey_files)
    clear survey; dat{run} = load(survey_files{run});
end
figure;


load(survey_files{1});

for i = 1:numel(dat{run}.survey.dat.response)
    if ~isempty(dat{run}.survey.dat.response{i})
        subplot(7,6,2*i-1), plot(dat{run}.survey.dat.response{i}(run,:));
        title(dims.name{i}, 'FontSize', 15); hold on; box off;
        %             ylim([-0.1, 1.1]);
        set(gcf, 'color', 'white');
        subplot(7,6,2*i), histogram(dat{run}.survey.dat.response{i}(run,:),30);
        title(dims.name{i}, 'FontSize', 15); hold on;
    end
end

%% event segmentation

seg_files = filenames(fullfile(pwd, '*rating01*word_seg*.mat'));
load(seg_files{1});

for run = 1:numel(seg_result)
    event_number(run,1) = (numel(seg_result{run}) - 15 + 1);
    a = find(count(seg_result{run}, '/'));
    event_size{run} = [a(1)-1 diff(a)-1 numel(seg_result{run})-a(end)];
end

%% hongji: compare in/out scanner ratings (for the last word)

datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
subdir_all = filenames(fullfile(datdir, 'coco0*'));

for sub_i = 1:numel(subdir_all)
    % in-scanner ft
    ft_files = filenames(fullfile(subdir_all{sub_i}, '*FT_run0*.mat'));
    type2_files = filenames(fullfile(subdir_all{sub_i}, '*rating02_19_dims_coco*.mat')); % out-scanner type2 (19 dims)
    type3_files = filenames(fullfile(subdir_all{sub_i}, '*rating03_fast*.mat')); % out-scanner type3 (5 dims)
    type3_dat = load(type3_files{1});
    for run_i = 1:numel(ft_files)
        clear data; load(ft_files{run_i});
        for dim = 1:5
            in_scanner{sub_i}(run_i,dim) = data.postrunQ.dat{dim}.rating;
            out_scanner.type3{sub_i}(run_i,dim) = type3_dat.survey.dat{run_i,15}{dim}.rating;
        end
        clear survey; load(type2_files{run_i});
        % type2
        % 1: self-relevance, 9: positive, 10: negative,
        % 11: safe, 12: threat, 16: vivid (concrete)
        target = [1, 9, 10, 11, 12, 16];
        count = 0;
        for t = 1:numel(target)
            count = count + 1;
            out_scanner.type2{sub_i}(run_i, count) = survey.dat.response{target(t)}(run_i,end);
        end
    end
end

res.in_scanner = in_scanner;
res.out_scanner = out_scanner;
%%
% sub_i = 1; clear a b c

a = []; b = []; c = [];

for sub_i = 8% [1:6, 8:9]
    a = [a; res.in_scanner{sub_i}]; % 4 runs * 5 dims
    b = [b; res.out_scanner.type2{sub_i}]; % 4 runs * 6 dims
    c = [c; res.out_scanner.type3{sub_i}]; % 4 runs * 5 dims
end

%
close all;
for dim = 1:5
    subplot(2,3,dim);
    s = scatter(a(:,dim), c(:,dim), 'filled'); lsline;
    s.MarkerFaceAlpha = 0.8;
    [r,p] = corr(a(:,dim), c(:,dim));
    title(['r = ', num2str(r,3), ', p = ', num2str(p,3)]);
end

%%
% type2
% 1: self-relevance, 9: positive, 10: negative,
% 11: safe, 12: threat, 16: vivid (concrete)
