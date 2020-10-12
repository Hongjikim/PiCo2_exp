%% directory setting

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
% datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
cd(datdir);
addpath(genpath(pwd));



%% Bar graph with segmentation data

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:20); % select manually
subnames(7:14) = subnames(8:15); %7 out
subnames(14) = subnames(16); %15 out
subnames = subnames(1:14);

for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    
    
    for d = 1:19
        
        post2scanner = cell(4, 15); % 10 : only dimensions need to compare with post2&in
        for run_i = 1:4
            for i = 1:15
                load(post_type2{run_i});
                post2scanner{run_i,i} = survey.dat.response{1,d}(run_i, i);
            end
        end
        
        color13 = [141,211,199; 255,255,179; 190,186,218; 251,128,114; 128,177,211; 253,180,98; 179,222,105; 252,205,229; 217,217,217; 188,128,189; 204,235,197; 255,237,111; 158,1,66]./255;
        
        figure;
        bpost = bar(cell2mat(post2scanner));
        title('post2scanner with 19dim')
        bpost.FaceColor = 'flat';
        
        n = 0;
        
%         a = find(count(seg_result, '/'));, [a(1) diff(a)-1]

        seg_num = input('how much context are there?');
        for i = 1:seg_num % num of chunks
            if i == 1
                seg_i(i) = input('Number of words in the same context? (1,3,10):'); % num of words in one chunk(context)
                for j = 1:seg_i(i)
                    bpost(j).FaceColor = color13(1,:);
                end
            else
                seg_i(i) = seg_i(i-1) + input('Number of words in the same context? (1,3,10):');
                n = n+1;
                for j = seg_i(i-1)+1:seg_i(i)
                    bpost(j).FaceColor = color13(n+1,:);
                end
            end
        end
        
    end
end
        
        
%         
%         mydata=rand(1,5);
% figure(1)
% hold on
% for i = 1:length(mydata)
%     h=bar(i,mydata(i));
%     if mydata(i) < 0.2
%         set(h,'FaceColor','k');
%     elseif mydata(i) < 0.6
%         set(h,'FaceColor','b');
%     else
%         set(h,'FaceColor','r');
%     end
% end
% hold off
        
        %
        %
        %         post3scanner = cell(1,60); % last word of which run
        %         colorfive = [251,128,114; 254,217,166; 255,255,179; 141,211,199; 128,177,211]./255; % ¿¬ÇÑ »ö
        %
        %         figure;
        %         bpost2 = bar(cell2mat(post3scanner));
        %         title('post3scanner_fast')
        %
        %         figure;
        %         binner = bar(cell2mat(inscanner));
        %         for i = 1:5
        %             bpost2(1,i).FaceColor = colorfive(i,:);
        %             binner(1,i).FaceColor = colorfive(i,:);
        %         end
        %         title('inscanner with 5dim')
        %     end
        
   
    


%% hongji's_scatter!

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:20); % select manually
subnames(7:14) = subnames(8:15); %7 out
subnames(14) = subnames(16); %15 out
subnames = subnames(1:14);

for whole = 1:5
    figure;
for sub_i = 1:numel(subnames)
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
            rating.post_type2_s(run_i,1) = survey.dat.response{1}(run_i,end); % self only
            rating.post_type2_v(run_i,1) = survey.dat.response{16}(run_i,end); % vivid only
            rating.post_type3(run_i,dd) = survey2.survey.dat{run_i,end}{dd}.rating;
            rating.post_type2_s_all(run_i,:) = survey.dat.response{1}(run_i,:); % self only
            rating.post_type2_v_all(run_i,:) = survey.dat.response{16}(run_i,:); % vivid only
            
            for w = 1:15
            rating.post_type3_all{run_i,w}{dd} = survey2.survey.dat{run_i,w}{dd}.rating;
            end
        end
    end

    
    if whole == 1
        % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
        figure;
        scatter(rating.inside(:), rating.post_type3(:));
        title('post3 / in for 5 dimensions sub');
        xlabel('post3');
        ylabel('inscanner');
        lsline;
        %hold on;

        
        
    elseif whole == 2
        % compare 1) self only 1 dims 4 words for each sub
        self = [];
        self(:,1) = rating.inside(:,2);
        self(:,2) = rating.post_type2_s;
        self(:,3) = rating.post_type3(:,2);
        
        figure;
        scatter(self(:,2), self(:,1));
        title('post2 / in for self only sub');
        xlabel('post2');
        ylabel('inscanner');
        lsline;
        %hold on;

        
    elseif whole == 3
        self2 = [];
        for i = 1:15
            for j = 1:4
                self2(i+15*(j-1),1) = rating.post_type2_s_all(j,i);
                self2(i+15*(j-1),2) = rating.post_type3_all{j,i}{2};
            end
        end
        
        figure;
        scatter(self2(:,1), self2(:,2));
        title('post2 / post3 for self only sub'); % 1dim, 60words for each sub
        xlabel('post2');
        ylabel('post3');
        lsline;
        %hold on;

        
    elseif whole == 4
        % compare 3) vivid only 1dim, 4words for each sub
        vivid = [];
        vivid(:,1) = rating.inside(:,4);
        vivid(:,2) = rating.post_type2_v;
        vivid(:,3) = rating.post_type3(:,4);
        
        figure;
        scatter(vivid(:,2), vivid(:,1));
        title('post2 / in for vivid only sub');
        xlabel('post2');
        ylabel('inscanner');
        lsline;
        %hold on;

        
    else
        vivid2 = []; % 1dim, 60words for each sub
        for i = 1:15
            for j = 1:4
                vivid2(i+15*(j-1),1) = rating.post_type2_v_all(j, i);
                vivid2(i+15*(j-1),2) = rating.post_type3_all{j,i}{4};
            end 
        end
        figure; % erase this to see combined scatter of all sub
        scatter(vivid2(:,1), vivid2(:,2));
        title('post2 / post3 for vivid only sub');
        xlabel('post2');
        ylabel('post3');
        lsline;
        % hold on; % reuse this for all the sub
        
        
    end
    
    
    
end
end



%% pre-resting & post resting


sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:20); % select manually
subnames(7:14) = subnames(8:15); %7 out
subnames(14) = subnames(16); %15 out
subnames = subnames(1:14);

%figure;
for sub_i = 1:numel(subnames)
    sub_dir = fullfile(datdir, subnames{sub_i});
    rest = filenames(fullfile(sub_dir, '*_resting_run*.mat'));
    type1 = [];
    
    for run_i = 1:numel(rest)
        load(rest{run_i});
        for i = 1:5
            type1(run_i, i) = data.postrunQ.dat{i}.rating;
        end
    end
    
    figure;
    scatter(type1(1, :), type1(2,:));
    title('pre / post for 5 dimensions sub');
    xlabel('pre-resting');
    ylabel('post-resting');
    lsline;
    %hold on;
            
    
end


%% plot
for a = 1:4, subplot(4,1,a), plot(cell2mat(post2scanner(a,:))'), end
seg_position = [3, 10, 11];

for i =1:numel(seg_position)
    xl = xline(seg_position(i)); xl.Color = [1 0 0];
    hold on;
end

