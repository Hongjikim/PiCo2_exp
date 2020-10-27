%% directory setting

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
% datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
cd(datdir);
addpath(genpath(pwd));

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:26); % select manually
subnames(7:21) = subnames(8:22); % 7 out
subnames(14:21) = subnames(15:22); % 15 out
subnames = subnames(1:20); % 1: numel(subnames)-# of extracted sub



%% Plot subject_wise graph for segmentation data

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/sub_wise';
mycolor = [27,158,119; 217,95,2; 117,112,179; 231,41,138;102,166,30;]./255; % 청록, 주황, 보라, 분홍, 연두

for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
   
    
    dd = cell(5,1); % 청록, 주황, 보라, 분홍, 연두val, self, time, vivid, safethreat
    load(post_type3{1}, 'survey');
    sub = subnames{sub_i};
    figure;
   
    
    for num_of_seg = 1:5 %19
       
        dd{num_of_seg} = survey.dat_descript{2+num_of_seg};
        post3scanner = cell(4, 15);
        
        for run_i = 1:4
            for i = 1:15
                post3scanner{run_i,i} = survey.dat{run_i,i}{1, num_of_seg}.rating;
            end
        end

        load(post_type1{1});
        
        for run_i = 1:4 %run num
            subplot(4,1,run_i), pl = plot(cell2mat(post3scanner(run_i,:))');
            pl.Color = mycolor(num_of_seg,:); pl.LineWidth = 1;
            title("Run" + run_i + extractBefore(sub, "_") +  extractAfter(sub, "_"))
            
            b = find(count(seg_result{1,run_i}, '/'));
            seg_position = b-[1:numel(b)];
            
            for x =1:numel(seg_position)
                xl = xline(seg_position(x)); xl.Color = [1 0 0]; xl.LineWidth = 2;
                hold on;
            end
            
            hold on;
        end
    end
    sub
    set(gcf, 'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf, fullfile(savedir, ["plot_seg_with_type3" + sub + '.png']))
    close all;
    clear title;
end

        

%% stacked bar plot for seg data

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/sub_wise';
cd('/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp');


for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    load(post_type1{1});
    
    for run_i = 1:4 %run num
        b = find(count(seg_result{1,run_i}, '/'));
        b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
        
        for i = 1:numel(b)
            seg(run_i, i) = b(i);
        end
        
    end
    
    S = [seg(1,:); seg(2,:); seg(3,:); seg(4,:)];
    mycolormap = cbrewer('div','Spectral',length(S));
    figure;
    segm = barh(S,'stacked');
    
    for i = 1:length(S)
        segm(i).FaceColor = mycolormap(i,:);
        segm(i).EdgeColor = mycolormap(i,:);
    end

    sub = subnames{sub_i};
    title("hBar " + extractBefore(sub, "_") +  extractAfter(sub, "_"));
    set(gcf, 'units','centimeters','Position',[8 0 35 35])
    saveas(gcf, fullfile(savedir, ["hBar " + sub + '.png']))
    close all;
    clear b;
    clear S;
    clear seg;
end

%% Violin plot for group-wise segmentation data

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/group_wise';
cd('/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp');
num_of_seg = 0;

for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    load(post_type1{1});
    c = 0;
    
    for run_i = 1:4 %run num
        num_of_seg(run_i, sub_i) = (numel(seg_result{1,run_i}) - 15 + 1);
        if isequal(run_i,1)
            b = find(count(seg_result{1,run_i}, '/'));
            b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
            
            for i = 1:numel(b)
                seg(sub_i, i) = b(i);
            end
        
        else
            c = numel(b)+c;
        
            b = find(count(seg_result{1,run_i}, '/'));
            b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
            
            for i = 1:numel(b)
                seg(sub_i, c+i) = b(i);
            end
        end
    end

end

% dd = violin(num_of_seg);
mycolor = [166,206,227; 31,120,180; 178,223,138; 51,160,44; 251,154,153; ...
227,26,28; 253,191,111; 255,127,0; 202,178,214; 106,61,154; ...
55,126,184; 77,175,74; 152,78,163; 27,158,119; 217,95,2; ...
117,112,179; 166,86,40; 247,129,191; 153,153,153; 166,206,227; 31,120,180;]./255;
boxplot_wani_2016(num_of_seg, 'color', mycolor, 'dots', 'nobox', 'violin');

title("# of segmentation chunks")
xlabel("subjects");
ylabel('# of segmentation chunks');
set(gcf, 'units','normalized','outerposition',[0 0 1 1])
saveas(gcf, fullfile(savedir, ["group_wise_segment_violin_plot" + '.png']))

% % wani violin plot
% boxplot_wani_2016(num_of_seg, 'dots', 'nobox', 'violin')

% all subject histogram
figure;
histogram(num_of_seg(:), 'facecolor', [mycolor(1, :)], 'edgecolor', [mycolor(2, :)]);
set(gcf, 'units','normalized','outerposition',[0 0 1 1])
title("segmentation data from each run histogram");
xlabel('# of segmented chunk of each run for each sub');
ylabel('frequency');
saveas(gcf, fullfile(savedir, ["group_wise_segment_hist" + '.png']))





%% Scatter_group wise

savedir  = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/scatter';

hj = 0;

for whole = 1:5
    figure;
    for sub_i = 1:numel(subnames)
        sub_dir = fullfile(datdir, subnames{sub_i});
        sub = subnames{sub_i};
        mr_run = filenames(fullfile(sub_dir, '*_FT_run*.mat'));
        post_type1 = filenames(fullfile(sub_dir, '*_rating01_word*.mat'));
        post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
        post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
        
        survey2 = load(post_type3{1});
        
        for run_i = 1:numel(mr_run)
            clear data survey
            load(mr_run{run_i}); load(post_type2{run_i});
            for dd = 1:5 % valence, self, time, vivid, safe&threat
                % in-scanner post-run "last word" rating
                rating.inside(run_i,dd) = data.postrunQ.dat{dd}.rating; % data from mr_run{run_i}, type1 inscanner
                % post-type2 (19 dim) "15 words" rating
                rating.post_type2_self(run_i,:) = survey.dat.response{1}(run_i,:); % self only
                rating.post_type2_pos(run_i,:) = survey.dat.response{9}(run_i,:); % positive only
                rating.post_type2_neg(run_i,:) = survey.dat.response{10}(run_i,:); % negative only
                rating.post_type2_vivid(run_i,:) = survey.dat.response{16}(run_i,:); % vivid only
                rating.post_type2_safe(run_i,:) = survey.dat.response{11}(run_i,:); % safe only
                rating.post_type2_threat(run_i,:) = survey.dat.response{12}(run_i,:); % threat only
                % post-type3 (5 dim) rating
                for w = 1:15
                    rating.post_type3_all{run_i,w}(dd) = survey2.survey.dat{run_i,w}{dd}.rating;
                end
            end
        end
        
        
        if whole == 1 %
            % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
            % compare "last word" from type3 and in-scanner rating
            % figure;
            for run_i = 1:4
                rating.post_type3_last_word(run_i, :) = rating.post_type3_all{run_i,15};
            end
            
            subplot(5, 4, sub_i)
            scatter(rating.inside(:,1), rating.post_type3_last_word(:,1),'MarkerEdgeAlpha',.7);
            title("Cor=" + corr(rating.inside(:,1), rating.post_type3_last_word(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_")  +  extractAfter(sub, "_"));
            xlabel('post3 valence dim');
            ylabel('inscanner valence dim');
            lsline;
            hold on;
            if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type1_3_valence_4words_allsub" + '.png'])); close all; end
            %val, self, time, vivid, safethreat
            
        elseif whole == 2 %
            % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
            % compare "last word" from type3 and in-scanner rating
            % figure;
            for run_i = 1:4
                rating.post_type3_last_word(run_i, :) = rating.post_type3_all{run_i,15};
            end
            
            subplot(5, 4, sub_i)
            scatter(rating.inside(:,2), rating.post_type3_last_word(:,2),'MarkerEdgeAlpha',.7);
            title("Cor=" + corr(rating.inside(:,2), rating.post_type3_last_word(:,2)) + " " + "sub0" + extractBetween(sub, "0", "_")  +  extractAfter(sub, "_"));
            xlabel('post3 self dim');
            ylabel('inscanner self dim');
            lsline;
            hold on;
            if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type1_3_self_4words_allsub" + '.png'])); close all; end
            %val, self, time, vivid, safethreat
            
        elseif whole == 3 %
            % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
            % compare "last word" from type3 and in-scanner rating
            % figure;
            for run_i = 1:4
                rating.post_type3_last_word(run_i, :) = rating.post_type3_all{run_i,15};
            end
            
            subplot(5, 4, sub_i)
            scatter(rating.inside(:,3), rating.post_type3_last_word(:,3),'MarkerEdgeAlpha',.7);
            title("Cor=" + corr(rating.inside(:,3), rating.post_type3_last_word(:,3)) + " " + "sub0" + extractBetween(sub, "0", "_")  +  extractAfter(sub, "_"));
            xlabel('post3 time dim');
            ylabel('inscanner time dim');
            lsline;
            hold on;
            if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type1_3_time_4words_allsub" + '.png'])); close all; end
            %val, self, time, vivid, safethreat
            
        elseif whole == 4 %
            % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
            % compare "last word" from type3 and in-scanner rating
            % figure;
            for run_i = 1:4
                rating.post_type3_last_word(run_i, :) = rating.post_type3_all{run_i,15};
            end
            
            subplot(5, 4, sub_i)
            scatter(rating.inside(:,4), rating.post_type3_last_word(:,4),'MarkerEdgeAlpha',.7);
            title("Cor=" + corr(rating.inside(:,4), rating.post_type3_last_word(:,4)) + " " + "sub0" + extractBetween(sub, "0", "_")  +  extractAfter(sub, "_"));
            xlabel('post3 vivid dim');
            ylabel('inscanner vivid dim');
            lsline;
            hold on;
            if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type1_3_vivid_4words_allsub" + '.png'])); close all; end
            %val, self, time, vivid, safethreat
            
            
        elseif whole == 5 %
            % compare 2) 5 dimensions (fig 7-8) 4 words for each sub
            % compare "last word" from type3 and in-scanner rating
            % figure;
            for run_i = 1:4
                rating.post_type3_last_word(run_i, :) = rating.post_type3_all{run_i,15};
            end
            
            subplot(5, 4, sub_i)
            scatter(rating.inside(:,5), rating.post_type3_last_word(:,5),'MarkerEdgeAlpha',.7);
            title("Cor=" + corr(rating.inside(:,5), rating.post_type3_last_word(:,5)) + " " + "sub0" + extractBetween(sub, "0", "_")  +  extractAfter(sub, "_"));
            xlabel('post3 safe&threat dim');
            ylabel('inscanner safe&threat dim');
            lsline;
            hold on;
            if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type1_3_safe&threat_4words_allsub" + '.png'])); close all; end
            %val, self, time, vivid, safethreat
            
%             
%             
%         elseif whole == 2
%             % compare 1) self only 1 dims 4 words for each sub
%             self = [];
%             self(:,1) = rating.inside(:,2);
%             self(:,2) = rating.post_type2_self(:, 15);
%             
%             for run_i = 1:4
%             type3_selflastwords(run_i,1) = rating.post_type3_all{run_i,15}(2);
%             end
%             
%             self(:,3) = type3_selflastwords;
%             
%             subplot(5, 4, sub_i)
%             scatter(self(:,2), self(:,1),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(self(:,2), self(:,1)) + " "+"sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_"));
%             xlabel('post2 self');
%             ylabel('inscanner self');
%             lsline;
%             hold on;
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_self_4words_allsub" + '.png'])); close all; end
%             
%             
%             
%         elseif whole == 3
%             self2 = [];
%             for i = 1:15
%                 for j = 1:4
%                     self2(i+15*(j-1),1) = rating.post_type2_self(j,i);
%                     self2(i+15*(j-1),2) = rating.post_type3_all{j,i}(2);
%                 end
%             end
%             
%             subplot(5, 4, sub_i)
%             scatter(self2(:,1), self2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(self2(:,2), self2(:,1))+ " " + "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_"));
%             xlabel('post2 self');
%             ylabel('post3 self');
%             lsline;
%             hold on;
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_self_60words_allsub" + '.png'])); close all; end
%             
%             
%         elseif whole == 4
%             
% %             hj = hj+1;
%             % compare 3) vivid only 1dim, 4words for each sub
%             vivid = [];
%             vivid(:,1) = rating.inside(:,4);
%             vivid(:,2) = rating.post_type2_vivid(:,end);
%             vivid(:,3) = rating.post_type3_last_word(:,4);
%             
%             subplot(5,4,sub_i);
%             scatter(vivid(:,2), vivid(:,1),'MarkerEdgeAlpha',.7);
%        
%             title("Cor=" + corr(vivid(:,2), vivid(:,1)) +" "+ "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_") );
%             xlabel('post2');
%             ylabel('inscanner');
%             lsline;
%              hold on;
%              if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_vivid_4words_allsub" + '.png'])); close all; end
%             
%             
%         elseif whole == 5
%             vivid2 = []; % 1dim, 60words for each sub
%             for i = 1:15
%                 for j = 1:4
%                     vivid2(i+15*(j-1),1) = rating.post_type2_vivid(j, i);
%                     vivid2(i+15*(j-1),2) = rating.post_type3_all{j,i}(4);
%                 end
%             end
%             
%             subplot(5, 4, sub_i);
%             scatter(vivid2(:,1), vivid2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(vivid2(:,2), vivid2(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_") + extractAfter(sub, "_"));
%             xlabel('post2');
%             ylabel('post3');
%             lsline;
%             hold on; % reuse this for all the sub
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_vivid_60words_allsub" + '.png'])); close all; end 
%             
%         elseif whole == 6 %type2 pos / in val
%             
%             val = []; % 1dim, 60words for each sub
%             val(:,1) = rating.inside(:,1);
%             val(:,2) = rating.post_type2_pos(:,end); 
%             val(:,3) = rating.post_type3_last_word(:,1);
%             
%             subplot(5,4,sub_i);
%             scatter(val(:,2), val(:,1),'MarkerEdgeAlpha',.7); 
%             title("Cor=" + corr(val(:,2), val(:,1)) +" "+ "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_") );
%             xlabel('post2 pos');
%             ylabel('inscanner val');
%             lsline;
%              hold on;
%              if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_pos_4words_allsub" + '.png'])); close all; end
%           
%         elseif whole == 7 %type2 neg, type3 val or in val
%          val2 = [];
%             for i = 1:15
%                 for j = 1:4
%                     val2(i+15*(j-1),1) = rating.post_type2_pos(j, i);
%                     val2(i+15*(j-1),2) = rating.post_type3_all{j,i}(1);
%                 end
%             end
%             
%             subplot(5, 4, sub_i);
%             scatter(val2(:,1), val2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(val2(:,2), val2(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_") + extractAfter(sub, "_"));
%             xlabel('post2 pos');
%             ylabel('post3 val');
%             lsline;
%             hold on; % reuse this for all the sub
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_pos_60words_allsub" + '.png'])); close all; end 
%  
%             
%         elseif whole == 8 
%             val = []; % 1dim, 60words for each sub
%             val(:,1) = rating.inside(:,1);
%             val(:,2) = rating.post_type2_neg(:,end);
%             val(:,3) = rating.post_type3_last_word(:,1);
%             
%             subplot(5,4,sub_i);
%             scatter(val(:,2), val(:,1),'MarkerEdgeAlpha',.7); 
%             title("Cor=" + corr(val(:,2), val(:,1)) +" "+ "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_") );
%             xlabel('post2 neg');
%             ylabel('inscanner val');
%             lsline;
%              hold on;
%              if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_neg_4words_allsub" + '.png'])); close all; end
%           
%             
%         elseif whole == 9 
%             val2 = [];
%             for i = 1:15
%                 for j = 1:4
%                     val2(i+15*(j-1),1) = rating.post_type2_neg(j, i);
%                     val2(i+15*(j-1),2) = rating.post_type3_all{j,i}(1);
%                 end
%             end
%             
%             subplot(5, 4, sub_i);
%             scatter(val2(:,1), val2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(val2(:,2), val2(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_") + extractAfter(sub, "_"));
%             xlabel('post2 neg');
%             ylabel('post3 val');
%             lsline;
%             hold on; % reuse this for all the sub
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_neg_60words_allsub" + '.png'])); close all; end 
%             
%             
%         elseif whole == 10
%              sfth = []; % 1dim, 60words for each sub
%             sfth(:,1) = rating.inside(:,5);
%             sfth(:,2) = rating.post_type2_safe(:,end); 
%             sfth(:,3) = rating.post_type3_last_word(:,5);
%             
%             subplot(5,4,sub_i);
%             scatter(sfth(:,2), sfth(:,1),'MarkerEdgeAlpha',.7); 
%             title("Cor=" + corr(sfth(:,2), sfth(:,1)) +" "+ "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_") );
%             xlabel('post2 safe');
%             ylabel('inscanner safe&threat');
%             lsline;
%              hold on;
%              if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_safe_4words_allsub" + '.png'])); close all; end
%           
%             
%             
%         elseif whole == 11
%            sfth2 = [];
%             for i = 1:15
%                 for j = 1:4
%                     sfth2(i+15*(j-1),1) = rating.post_type2_safe(j, i);
%                     sfth2(i+15*(j-1),2) = rating.post_type3_all{j,i}(5);
%                 end
%             end
%             
%             subplot(5, 4, sub_i);
%             scatter(sfth2(:,1), sfth2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(sfth2(:,2), sfth2(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_") + extractAfter(sub, "_"));
%             xlabel('post2 safe');
%             ylabel('post3 safe&threat');
%             lsline;
%             hold on; % reuse this for all the sub
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_safe_60words_allsub" + '.png'])); close all; end 
%             
%             
%         elseif whole == 12 %type2 safe, type3 sfth of in sfth
%              sfth = []; % 1dim, 60words for each sub
%             sfth(:,1) = rating.inside(:,5);
%             sfth(:,2) = rating.post_type2_threat(:,end); 
%             sfth(:,3) = rating.post_type3_last_word(:,5);
%             
%             subplot(5,4,sub_i);
%             scatter(sfth(:,2), sfth(:,1),'MarkerEdgeAlpha',.7); 
%             title("Cor=" + corr(sfth(:,2), sfth(:,1)) +" "+ "sub0" + extractBetween(sub, "0", "_") +  extractAfter(sub, "_") );
%             xlabel('post2 threat');
%             ylabel('inscanner safe&threat');
%             lsline;
%              hold on;
%              if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_1_threat_4words_allsub" + '.png'])); close all; end
%           
%             
%         else % type2 threat, type3 sfth or in sfth
%             sfth2 = [];
%             for i = 1:15
%                 for j = 1:4
%                     sfth2(i+15*(j-1),1) = rating.post_type2_threat(j, i);
%                     sfth2(i+15*(j-1),2) = rating.post_type3_all{j,i}(5);
%                 end
%             end
%             
%             subplot(5, 4, sub_i);
%             scatter(sfth2(:,1), sfth2(:,2),'MarkerEdgeAlpha',.7)
%             title("Cor=" + corr(sfth2(:,2), sfth2(:,1)) + " " + "sub0" + extractBetween(sub, "0", "_") + extractAfter(sub, "_"));
%             xlabel('post2 threat');
%             ylabel('post3 safe&threat');
%             lsline;
%             hold on; % reuse this for all the sub
%             if isequal(sub_i, numel(subnames)); set(gcf, 'units','normalized','outerposition',[0 0 1 1]); saveas(gcf, fullfile(savedir, ["type2_3_threat_60words_allsub" + '.png'])); close all; end 
%             
        end
    end
end

        

%% hongji's_scatter!


savedir31 =  '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/scatter/type3_In';
savedir21 = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/scatter/type2_in';
savedir23 = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/scatter/type2_type3';

for whole = 1:5
    figure;
for sub_i = 1:numel(subnames)
    sub_dir = fullfile(datdir, subnames{sub_i});
    sub = subnames{sub_i};
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
        scatter(rating.inside(:), rating.post_type3(:),'MarkerEdgeAlpha',.7);
        title("post3 / in for slef in" + sub + "(4words)"+ "cor=" + corr(rating.inside(:), rating.post_type3(:)));
        xlabel('post3');
        ylabel('inscanner');
        lsline;
        %hold on;
        saveas(gcf, fullfile(savedir31, ["type3_1_5dim_4words_" + sub + '.png']))
        close all
        
        
    elseif whole == 2
        % compare 1) self only 1 dims 4 words for each sub
        self = [];
        self(:,1) = rating.inside(:,2);
        self(:,2) = rating.post_type2_s;
        self(:,3) = rating.post_type3(:,2);
        
        figure;
        scatter(self(:,2), self(:,1),'MarkerEdgeAlpha',.5)
        title("post2 / in for self dim in " + sub +"(4words)" + "cor=" + corr(self(:,2), self(:,1)));
        xlabel('post2');
        ylabel('inscanner');
        lsline;
        %hold on;
        saveas(gcf, fullfile(savedir21, ["type2_1_self_4words_" + sub + '.png']))
        close all

        
    elseif whole == 3
        self2 = [];
        for i = 1:15
            for j = 1:4
                self2(i+15*(j-1),1) = rating.post_type2_s_all(j,i);
                self2(i+15*(j-1),2) = rating.post_type3_all{j,i}{2};
            end
        end
        
        figure;
        scatter(self2(:,1), self2(:,2),'MarkerEdgeAlpha',.7)
        title("post2 / post3 for self dim in "+ sub+ "(60words)" + "cor=" + corr(self2(:,1),(self2(:,2)))); % 1dim, 60words for each sub
        xlabel('post2');
        ylabel('post3');
        lsline;
        %hold on;
        saveas(gcf, fullfile(savedir23, ["type2_3_self_60words_" + sub + '.png']))
        close all

        
    elseif whole == 4
        % compare 3) vivid only 1dim, 4words for each sub
        vivid = [];
        vivid(:,1) = rating.inside(:,4);
        vivid(:,2) = rating.post_type2_v;
        vivid(:,3) = rating.post_type3(:,4);
        
        figure;
        scatter(vivid(:,2), vivid(:,1),'MarkerEdgeAlpha',.5);
        title("post2 / in for vivid dim in " + sub + "(4words)" + "cor=" + corr(vivid(:,2),(vivid(:,2))))
        xlabel('post2');
        ylabel('inscanner');
        lsline;
        %hold on;
        saveas(gcf, fullfile(savedir21, ["type2_1_vivid_4words_" + sub + '.png']))
        close all

        
    else
        vivid2 = []; % 1dim, 60words for each sub
        for i = 1:15
            for j = 1:4
                vivid2(i+15*(j-1),1) = rating.post_type2_v_all(j, i);
                vivid2(i+15*(j-1),2) = rating.post_type3_all{j,i}{4};
            end 
        end
        figure; % erase this to see combined scatter of all sub
        scatter(vivid2(:,1), vivid2(:,2),'MarkerEdgeAlpha',.7)
        title("post2 / post3 for vivid dim in " + sub + "(60words)" + "cor=" +corr(vivid2(:,1),(vivid2(:,2))))
        xlabel('post2');
        ylabel('post3');
        lsline;
        % hold on; % reuse this for all the sub
        saveas(gcf, fullfile(savedir23, ["type2_3_vivid_60words_" + sub + '.png']))
        close all
        
        
    end
    
    
    
end
end

% savename??