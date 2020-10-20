%% directory setting

datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';
% datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
cd(datdir);
addpath(genpath(pwd));



%% Plot subject_wise graph for segmentation data

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subnames = subnames(1:19); % 1: numel(subnames)-# of extracted sub

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/sub_wise';

for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    
%     dd = cell(19,1);
%     load(post_type2{1}, 'survey');
%     sub = extractBefore(cell2mat(subnames(sub_i)), "_");
%     figure;
    
    dd = cell(5,1);
    load(post_type3{1}, 'survey');
    sub = subnames{sub_i};
    figure;
   
    
    for d = 1:5 %19
        %dd{d} = survey.dat.whole_dims.name{d};
        %post2scanner = cell(4, 15); % 10 : only dimensions need to compare with post2&in
        
%         for run_i = 1:4
%             for i = 1:15
%                 load(post_type2{run_i});
%                 post2scanner{run_i,i} = survey.dat.response{1,d}(run_i, i);
%             end
%         end

        dd{d} = survey.dat_descript{2+d};
        post3scanner = cell(4, 15);
        
        for run_i = 1:4
            for i = 1:15
                post3scanner{run_i,i} = survey.dat{run_i,i}{1, d}.rating;
            end
        end

        load(post_type1{1});
        
        for a = 1:4 %run num
            subplot(4,1,a), plot(cell2mat(post3scanner(a,:))')
            title("Run" + a + sub)
            
            b = find(count(seg_result{1,a}, '/'));
            seg_position = b-[1:numel(b)];
            
            for x =1:numel(seg_position)
                xl = xline(seg_position(x)); xl.Color = [1 0 0];
                hold on;
            end
            
            hold on;
        end
    end
    sub
    title("segmentation plot with type3 5dims" + sub);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf, fullfile(savedir, ["plot_seg_with_type3" + sub + '.png']))
    close all;
    clear title;
end

        

%% stacked bar plot for seg data

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subnames = subnames(1:19); % 1: numel(subnames)-# of extracted sub

savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/sub_wise';
cd('/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp');


for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    load(post_type1{1});
    
    for a = 1:4 %run num
        b = find(count(seg_result{1,a}, '/'));
        b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
        
        for i = 1:numel(b)
            seg(a, i) = b(i);
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
    title("hBar_" + sub);
    set(gcf, 'units','centimeters','Position',[8 0 35 35])
    saveas(gcf, fullfile(savedir, ["hBar_" + sub + '.png']))
    close all;
    clear b;
    clear S;
    clear seg;
end

%% Violin plot for group-wise segmentation data

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subnames = subnames(1:19); % 1: numel(subnames)-# of extracted sub


savedir = '/Users/dongjupark/Dropbox/onlyme/PICO2/behavioral_result/word_seg/group_wise';
cd('/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp');
d = 0;

for sub_i = 1:numel(subnames)
    
    sub_dir = fullfile(datdir, subnames{sub_i});
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word_seg*.mat'));
    load(post_type1{1});
    c = 0;
    
    for a = 1:4 %run num
        d(a, sub_i) = (numel(seg_result{1,a}) - 15 + 1);
        if isequal(a,1)
            b = find(count(seg_result{1,a}, '/'));
            b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
            
            for i = 1:numel(b)
                seg(sub_i, i) = b(i);
            end
        
        else
            c = numel(b)+c;
        
            b = find(count(seg_result{1,a}, '/'));
            b = [[b(1) diff(b)]-1 15-sum([b(1) diff(b)]-1)];
            
            for i = 1:numel(b)
                seg(sub_i, c+i) = b(i);
            end
        end
    end

end

figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1])
dd = violin(d);
mycolor = [141,211,199; 255,255,179; 190,186,218; 251,128,114; 128,177,211; 253,180,98;179,222,105; 252,205,229; 217,217,217;188,128,189;204,235,197;255,237,111;166,206,227;31,120,180;178,223,138;51,160,44;251,154,153; 53,151,143; 1,102,94]./255;

for i = 1:19
dd(i).FaceColor = mycolor(i, :);
dd(i).EdgeColor = mycolor(i, :);
end


title("# of segmentation chunks")
xlabel("subjects");
ylabel('# of segmentation chunks');
saveas(gcf, fullfile(savedir, ["group_wise_segment_violin_plot" + '.png']))




%% Heatmap





%% Check graph



%% subject wise?????

        

%% hongji's_scatter!


sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:25); % select manually
subnames(7:20) = subnames(8:21); % 7 out
subnames(14:20) = subnames(15:21); % 15 out
subnames = subnames(1:19); % 1: numel(subnames)-# of extracted sub


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
        title("4words post3 / in for 5 dims in _" + sub);
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
        title("4words post2 / in for self dim in _" + sub);
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
        title("60words post2 / post3 for self dim in _" + sub); % 1dim, 60words for each sub
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
        title("4words post2 / in for vivid dim in _" + sub);
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
        title("60words post2 / post3 for vivid dim in _" + sub);
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