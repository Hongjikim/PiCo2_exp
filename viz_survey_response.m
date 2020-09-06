%%
% dims.name = {'자기 관련도', '긍정', '부정', '중요도', '관계성', '중심성', '과거', '현재', '미래', ...
%     '빈도', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', '추상정/관념성', ...
%     '자발성', '목표'};

dims.name = {'self-relevance', 'positive', 'negetive', 'importance/value', 'social', 'centrality', 'past', 'present', 'future' ...
    'frequency', 'safe', 'threat', 'imagery', 'word', 'intensity', 'detail(vivid)', ...
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
%% subject-wise result

clf;

survey_files = filenames(fullfile(pwd, '*rating02_19_dims*.mat'));
for run = 1:numel(survey_files)
    clear survey; dat{run} = load(survey_files{run});
end
figure;
for run = 3 %1:numel(survey_files)
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
end

%% group-wise result

clf;
basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
% basedir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';
datdir = fullfile(basedir, 'data');

subject_codes = {'coco006_psj', 'coco008_kjw', 'coco010_khb', 'coco011_lada'};

count = 0;
for sub_num = 1:numel(subject_codes)
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

% for i = 1:numel(dat_all)
%     subplot(7,6,2*i-1), plot(dat_all{i});
%     title(dims.name{i}); hold on; box off;
%     %             ylim([-0.1, 1.1]);
%     set(gcf, 'color', 'white');
%     subplot(7,6,2*i), histogram(dat_all{i},30);
%     title(dims.name{i}); hold on;
% end
%%

% histogram only
clf;
for i = 1:numel(dat_all)
    subplot(4,5,i)
    histogram(dat_all{i}, 20);
    set(gcf, 'color', 'white');
    title(dims.name{i}, 'FontSize', 30); hold on;
end

% correlation imagesc
for i = 1:numel(dat_all)
    new_dat(i,:) = dat_all{i}(:)';
end

clf; imagesc(corr(new_dat')); colorbar;
set(gca, 'XTick', 1:19, 'XTickLabel', dims.name, 'FontSize', 22); xtickangle(30);
set(gca, 'YTick', 1:19, 'YTickLabel', dims.name, 'FontSize', 22); ytickangle(30);

%% threshold with r and p values
[r, p] = corrcoef(new_dat');

temp = r.*(p < 0.05);
clf; imagesc(temp.*(r < -0.4 | r > 0.4)); colorbar;
set(gca, 'XTick', 1:19, 'XTickLabel', dims.name, 'FontSize', 22); xtickangle(30);
set(gca, 'YTick', 1:19, 'YTickLabel', dims.name, 'FontSize', 22); ytickangle(30);

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