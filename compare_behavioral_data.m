%% directory setting

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
% datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
cd(datdir);
addpath(genpath(pwd));

%% Bar graph
sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:6); % select manually

for sub_i = 1:numel(subnames)
    
    surveylist = dir(cell2mat(fullfile(datdir, subnames(sub_i)))); % change 1 to num of sub you want
    sub_dir = fullfile(datdir, subnames{sub_i});
    surveynames = {surveylist.name}';
    
    for i = 1:numel(surveynames)
        % if surveynames
        mr_run = filenames(fullfile(sub_dir, '*_FT_run*.mat'));
        post_type1 = filenames(fullfile(sub_dir, '*_rating01_word*.mat'));
        post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
        post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
        
        
        inscanner = cell(4,5); % last word of which run
        for i = 1:4 % inscanner run 01~04
            for j = 1:5 % valence / self / time / vivid / safety&threat
                load(mr_run{i})
                inscanner{i,j} = data.postrunQ.dat{1,j}.rating;
            end
        end
        
        post2scanner = cell(4, 10); % 10 : only dimensions need to compare with post2&in
        for i = 7:10 % surveydata run1~4
            k = 1;
            for j = [2 3 1 7 8 9 16 17 11 12] % pos, neg, self, past, present, future, concret, abstract, safety, threat
                load(post_type2{i-6});
                post2scanner{i-6, k} = survey.dat.response{1,j}(i-6,15);
                k = k+1;
            end
        end
        
        post3scanner = cell(4,5); % last word of which run
        for i = 1:4 %runs
            for j = 1:5 %
                load(post_type3{1});
                post3scanner{i,j} = survey.dat{i,15}{1,j}.rating;
            end
        end
    end
    
    
    % Figure1-3 : barplot for post, post2, inscanner
    
    color10 = [158,1,66; 213,62,79; 244,109,67; 253,174,97; 254,224,139; 230,245,152; 171,221,164; 102,194,165; 50,136,189; 94,79,162]./255;
    
    figure;
    bpost = bar(cell2mat(post2scanner));
    for i = 1:10
        bpost(1,i).FaceColor = color10(i,:); % 빨간색~보라색
    end
    title('post2scanner with 19dim')
    
    colorfive = [251,128,114; 254,217,166; 255,255,179; 141,211,199; 128,177,211]./255; % 연한 색
    
    figure;
    bpost2 = bar(cell2mat(post3scanner));
    title('post3scanner_fast')
    
    figure;
    binner = bar(cell2mat(inscanner));
    for i = 1:5
        bpost2(1,i).FaceColor = colorfive(i,:);
        binner(1,i).FaceColor = colorfive(i,:);
    end
    title('inscanner with 5dim')
    
    
end

%% Figures
%
% % Figure1 : scatter plot for post2 / in
% % color of surrounding line = run num, marker color = dimensions
%
% vividcolor9 = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0; 255,255,51; 166,86,40; 247,129,191; 153,153,153]./255;
% % red, blue, green, purple : run1-4, % orange, yellow, brown, pink, grey : v, s, t, v, s&th
% figure;
% for i = 1:4
%     for j = 1:5 % valence, self, time, vivid, safe&threat
%         % last word of which run
%         post2in = scatter([post3scanner{i,j}], [inscanner{i,j}]', [], 'filled', 'MarkerEdgeColor', [vividcolor9(i,:)], 'MarkerFaceColor', [vividcolor9(j+4,:)]);
%         post2in.SizeData = 200;
%         post2in.LineWidth = 5;
%         hold on;
%     end
% end
%
%
% % Figure2 : scatter plot for post2/in on every run's last word
% % last word of which run
%
% figure;
% for i = 1:4
%     for j = 1:5 % valence, self, time, vivid, safe&threat
%         scatter([post3scanner{i,j}], [inscanner{i,j}]', [], 'filled', 'MarkerEdgeColor', [vividcolor9(j+4,:)], 'MarkerFaceColor', [vividcolor9(j+4,:)]);
%         hold on
%     end
% end
%
% % Question : Can I draw correlation line on Figure2 with lsline?
% % I think it doesn't work because each elements were drown separately by 'hold on' function.
%
%
% % Figure3-5 : barplot for post, post2, inscanner
%
% color10 = [158,1,66; 213,62,79; 244,109,67; 253,174,97; 254,224,139; 230,245,152; 171,221,164; 102,194,165; 50,136,189; 94,79,162]./255;
%
% figure;
% bpost = bar(cell2mat(post2scanner));
% for i = 1:10
% bpost(1,i).FaceColor = color10(i,:); % 빨간색~보라색
% end
% title('post2scanner with 19dim')
%
% colorfive = [251,128,114; 254,217,166; 255,255,179; 141,211,199; 128,177,211]./255; % 연한 색
%
% figure;
% bpost2 = bar(cell2mat(post3scanner));
% title('post3scanner_fast')
%
% figure;
% binner = bar(cell2mat(inscanner));
% for i = 1:5
%     bpost2(1,i).FaceColor = colorfive(i,:);
%     binner(1,i).FaceColor = colorfive(i,:);
% end
% title('inscanner with 5dim')

%% hongji's_scatter!

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:6); % select manually

for sub_i = 1:2 %numel(subnames)
    sub_dir = fullfile(datdir, subnames{sub_i});
    mr_run = filenames(fullfile(sub_dir, '*_FT_run*.mat'));
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word*.mat'));
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    
    survey2 = load(post_type3{1});
    
    for run_i = 1:numel(mr_run)
        clear data survey
        load(mr_run{run_i}); load(post_type2{run_i});
        for dd = 1:5 % valence, self, time, vivid, safe&threat
            rating.inside(run_i,dd) = data.postrunQ.dat{dd}.rating;
            rating.post_type2(run_i,1) = survey.dat.response{1}(run_i,end); % self only
            rating.post_type3(run_i,dd) = survey2.survey.dat{run_i,end}{dd}.rating;
            rating.post_type2_all(run_i,:) = survey.dat.response{1}(run_i,:); % self only
            %             rating.post_type3_all(run_i,:){dd} = survey2.survey.dat{run_i,:}{dd}.rating;
        end
    end
    
    % compare 1) self only
    self = [];
    self(:,1) = rating.inside(:,2);
    self(:,2) = rating.post_type2;
    self(:,3) = rating.post_type3(:,2);
    
    figure;
    scatter(self(:,2), self(:,1));
    title('post2 / in for self only sub');
    xlabel('post2');
    ylabel('inscanner');
    lsline;
    
    figure;
    scatter(self(:,2), self(:,3));
    title('post2 / post3 for self only sub');
    xlabel('post2');
    ylabel('post3');
    lsline;
    
    % compare 2) 5 dimensions (fig 7-8)
    figure;
    scatter(rating.inside(:), rating.post_type3(:));
    title('post3 / in for 5 dimensions sub');
    xlabel('post3');
    ylabel('inscanner');
    lsline;
end



%
% % compare 1) self only
% self = [];
% self(:,1) = rating.inside(:,2);
% self(:,2) = rating.post_type2;
% self(:,3) = rating.post_type3(:,2);
%
% % scatter(self(:,1), self(:,2))
%
% % compare 2) 5 dimensions
%
% scatter(rating.inside(:), rating.post_type3(:))

%%
for run = 1:4
    count = 0;

    for i = 1:15
        count = count + 1;
        type3(run,count) = survey2.survey.dat{run,i}{2}.rating;
        
    end
end
for run_i = 1:4
    load(post_type2{run_i});
    type2(run_i,:) = survey.dat.response{1}(run_i,:);
end

scatter(type2(:), type3(:))