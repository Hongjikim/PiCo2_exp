

inscanner = cell(4,5); %(5, 6); % 어차피 1개 단어
filenames = {'20200826_coco001_HJW_resting_run01.mat', '20200826_coco001_HJW_FT_run01.mat', '20200826_coco001_HJW_FT_run02.mat', '20200826_coco001_HJW_FT_run03.mat', '20200826_coco001_HJW_FT_run04.mat', '20200826_coco001_HJW_resting_run02.mat'};

for i = 1:4 %6 % 6 runs (pre-resting, 1-4, post-resting)
    for j = 1:5 % valence / self / time / vivid / safety&threat
        load(filenames{i}) 
        inscanner{i,j} = data.postrunQ.dat{1,j}.rating;
    end
end

clear filenames;
postscanner = cell(4, 9); % 런마다 마지막 단어
filenames = {'20200826_surveydata_coco001_hjw_run1.mat', '20200826_surveydata_coco001_hjw_run2.mat', '20200826_surveydata_coco001_hjw_run3.mat', '20200826_surveydata_coco001_hjw_run4.mat'};


for i = 1:4
    k = 1;
    for j = [1 2 3 7 8 9 11 12 16]
        load(filenames{i});
        postscanner{i, k} = survey.dat.response{1,j}(i,15);
        k = k+1;
    end
end

clear filenames;
post2scanner = cell(4,5); % 런마다 마지막 단어
for i = 1:4 %runs
    for j = 1:5 %
        load('surveydata_subcoco001_hjw.mat');
        post2scanner{i,j} = survey.dat{i,15}{1,j}.rating;
    end
end

color = [27,158,119; 217,95,2; 117,112,179; 231,41,138; 102,166,30]./255; % run 1-4
% 청록색, 주황색, 보라색, 분홍색, 녹색
for j = 1:5 % valence, self, time, vivid, safe&threat 
    scatter([post2scanner{:,j}], [inscanner{:,j}]', [], cols(sub,:), 'filled', 'MarkerEdgeColor', [color(j,:)], 'MarkerFaceColor', [color(j,:)]);, lsline;
    hold on;
end




