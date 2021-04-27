datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data'; %for session2 _session2';
%datdir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp/data';
cd(datdir);
addpath(genpath(pwd));

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:end-4); %for session2 (4:end);

savedir = '/Users/dongjupark/Dropbox/PiCo2_sync/figures/behavioral/behav_sanity_check/correlation_among_tasks';
%savedir = '/Users/hongji/Dropbox/PiCo2_sync/figures/behavioral/behav_sanity_check/correlation_among_tasks';

%% type 3 | in_scanner

dims = ["VAL"; "SELF"; "TIME"; "VIVID"; "SAFTH"; "ALL"];
dims2 = ["self"; "pos"; "neg"; "vivid"; "safe"; "threat"];

for sub_i = 1:numel(subnames)
    close all;
    figure; set(gcf, 'units','normalized','outerposition',[0 0 1/2 1]);
    sub_dir = fullfile(datdir, subnames{sub_i});
    sub = subnames{sub_i};
    sub = extractBefore(sub, "_");
    mr_run = filenames(fullfile(sub_dir, '*_FT_run*.mat'));
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word*.mat'));
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    
    survey2 = load(post_type3{1});
    
    for run_i = 1:numel(mr_run)
%         clear data survey rating
        load(mr_run{run_i}); load(post_type2{run_i});
        for dd = 1:5 % valence, self, time, vivid, safe&threat
            rating.inside(run_i,dd) = data.postrunQ.dat{dd}.rating;
            rating.post_type3(run_i,dd) = survey2.survey.dat{run_i,end}{dd}.rating;
            rating.post_type2_self(run_i,:) = survey.dat.response{1}(run_i,:); % self only
            rating.post_type2_pos(run_i,:) = survey.dat.response{9}(run_i,:); % positive only
            rating.post_type2_neg(run_i,:) = survey.dat.response{10}(run_i,:); % negative only
            rating.post_type2_vivid(run_i,:) = survey.dat.response{16}(run_i,:); % vivid only
            rating.post_type2_safe(run_i,:) = survey.dat.response{11}(run_i,:); % safe only
            rating.post_type2_threat(run_i,:) = survey.dat.response{12}(run_i,:); % threat only
            
            for w = 1:15
                rating.post_type3_all{dd}{run_i,w} = survey2.survey.dat{run_i,w}{dd}.rating;
            end
        end
    end
    
    for whole = 1:18
        if whole == 1 || whole == 2 || whole == 5
            subplot(6,3,(whole*3)+1);
            %             scatter(rating.inside(:, whole), rating.post_type3(:, whole),'MarkerEdgeAlpha',.5);
            clear s
            scatter(rating.inside(:, whole), rating.post_type3(:, whole),'filled', ...
                'MarkerFaceColor','r','MarkerEdgeColor','r', 'MarkerEdgeAlpha',.8, ...
                'MarkerFaceAlpha', .3);
            [R,p]=corrcoef(rating.inside(:, whole), rating.post_type3(:, whole));
            title(dims{whole} + " cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),2)), 'FontSize', 14);
            xlabel('inscanner', 'FontSize', 15);
            ylabel('type3', 'FontSize', 15);
            
            l = lsline;
            l.LineWidth = 1; l.Color = [1 0 0 0.5]; %'r'; l.LineStyle = '--';
            
            if any(whole == [1, 3, 5])
                set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 1.1]);
            else
                set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);
            end
            
            hold on;
            
        elseif whole == 3 || whole == 4
            subplot(6,3,22-(whole*3));
            scatter(rating.inside(:, whole), rating.post_type3(:, whole),'filled', ...
                'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',.8, ...
                'MarkerFaceAlpha', .3);
            [R,p]=corrcoef(rating.inside(:, whole), rating.post_type3(:, whole));
            title(dims{whole} + " cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),2)), 'FontSize', 14);
            xlabel('inscanner', 'FontSize', 15);
            ylabel('type3', 'FontSize', 15);
            
            l = lsline;
            l.LineWidth = 1; l.Color = [1 0 0 0.5]; %'r'; l.LineStyle = '--';
            
            if any(whole == [1, 3, 5])
                set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 1.1]);
            else
                set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);
            end
            
            hold on;
            
        elseif whole == 6
            subplot(6,3,1);
            %             scatter(rating.inside(:), rating.post_type3(:),'MarkerEdgeAlpha',.5);
            scatter(rating.inside(:), rating.post_type3(:),'filled', ...
               'MarkerFaceColor','r','MarkerEdgeColor','r', 'MarkerEdgeAlpha',.8, ...
                'MarkerFaceAlpha', .3);
            [R,p]=corrcoef(rating.inside(:), rating.post_type3(:));
            title(dims{whole} + " cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),2)), 'FontSize', 14);
            xlabel('inscanner', 'FontSize', 15);
            ylabel('type3', 'FontSize', 15);
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 1.1]);
            
            l = lsline;
            l.LineWidth = 1; l.Color = 'r';
            hold on;
            
%             ss = [];
%             while true
%                 ss = input('continue? :', 's');
%                 if ss == 'y'
%                     break
%                 end
%             end
            

        elseif whole == 7
            subplot(6, 3, 2)
            scatter(cell2mat(rating.post_type3_all{1}(:)), rating.post_type2_pos(:), 'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225,'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{1}(:)), rating.post_type2_pos(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 val', 'FontSize', 15);
            ylabel("post2 " + dims2{whole-5}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;
            hold on;
            
        elseif whole == 8
            subplot(6, 3, 5)
            scatter(cell2mat(rating.post_type3_all{1}(:)), -rating.post_type2_neg(:),'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225,'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{1}(:)), -rating.post_type2_neg(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 val', 'FontSize', 15);
            ylabel("(-) post2 " + dims2{whole-5}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;

            hold on;
            
        elseif whole == 9
            subplot(6, 3, 11)
            scatter(cell2mat(rating.post_type3_all{whole-5}(:)), rating.post_type2_vivid(:),'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{whole-5}(:)), rating.post_type2_vivid(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel("post3 " + dims2{whole-5}, 'FontSize', 15);
            ylabel("post2 " + dims2{whole-5}, 'FontSize', 15);
            
            set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;

            hold on;
            
        elseif whole == 10
            subplot(6, 3, 14)
            scatter(cell2mat(rating.post_type3_all{whole-5}(:)), rating.post_type2_safe(:),'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{whole-5}(:)), rating.post_type2_safe(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 safe&threat', 'FontSize', 15);
            ylabel("post2 " + dims2{whole-5}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;

            hold on;
            
        elseif whole == 11
            subplot(6, 3, 17)
            scatter(cell2mat(rating.post_type3_all{whole-6}(:)), -rating.post_type2_threat(:), 'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{whole-6}(:)), -rating.post_type2_threat(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 safe&threat', 'FontSize', 15);
            ylabel("(-) post2 " + dims2{whole-5},'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;

            hold on;
            
        elseif whole == 12
            subplot(6, 3, 8)
            scatter(cell2mat(rating.post_type3_all{2}(:)), rating.post_type2_self(:),'filled', ...
                'MarkerFaceColor',[55,126,184]./225,'MarkerEdgeColor',[55,126,184]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(cell2mat(rating.post_type3_all{2}(:)), rating.post_type2_self(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 self', 'FontSize', 15);
            ylabel("post2 " + dims2{1}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [55,126,184]./225;

            hold on;


            
        elseif whole == 13
            subplot(6, 3, 3)
            scatter(rating.inside(:, whole-12), rating.post_type2_pos(:, end), 'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-12), rating.post_type2_pos(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('inscanner val', 'FontSize', 15);
            ylabel("post2 " + dims2{2}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;
            hold on;
            
        elseif whole == 14
            subplot(6, 3, 6)
            scatter(rating.inside(:, whole-13), -rating.post_type2_neg(:, end),'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225,'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-13), -rating.post_type2_neg(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('inscanner val', 'FontSize', 15);
            ylabel("(-) post2 " + dims2{3}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;

            hold on;
            
        elseif whole == 15
            subplot(6, 3, 12)
            scatter(rating.inside(:, whole-11), rating.post_type2_vivid(:, end),'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-11), rating.post_type2_vivid(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel("inscanner " + dims2{whole-11}, 'FontSize', 15);
            ylabel("post2 " + dims2{whole-11}, 'FontSize', 15);
            
            set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;

            hold on;
            
        elseif whole == 16
            subplot(6, 3, 15)
            scatter(rating.inside(:, whole-11), rating.post_type2_safe(:, end),'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-11), rating.post_type2_safe(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('inscanner safe&threat', 'FontSize', 15);
            ylabel("post2 " + dims2{whole-11}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;

            hold on;
            
        elseif whole == 17
            subplot(6, 3, 18)
            scatter(rating.inside(:, whole-12), -rating.post_type2_threat(:, end), 'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-12), -rating.post_type2_threat(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('inscanner safe&threat', 'FontSize', 15);
            ylabel("(-) post2 " + dims2{whole-12},'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;

            hold on;
            
        else
            subplot(6, 3, 9)
            scatter(rating.inside(:, whole-16), rating.post_type2_self(:, end),'filled', ...
                'MarkerFaceColor',[0,109,44]./225,'MarkerEdgeColor',[0,109,44]./225, 'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.inside(:, whole-16), rating.post_type2_self(:, end));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('inscanner self', 'FontSize', 15);
            ylabel("post2 " + dims2{1}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = [0,109,44]./225;

            hold on;
            
            

            saveas(gcf, fullfile(savedir, ["all " + sub + '.png']));

        end
    end
end




%% type 3 | type 2


dims = [];
dims = ["self"; "pos"; "neg"; "vivid"; "safe"; "threat";];

for sub_i = 40%1:numel(subnames)
    close all;
    figure; set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    sub_dir = fullfile(datdir, subnames{sub_i});
    sub = subnames{sub_i};
    sub = extractBefore(sub, "_");
    mr_run = filenames(fullfile(sub_dir, '*_FT_run*.mat'));
    post_type1 = filenames(fullfile(sub_dir, '*_rating01_word*.mat'));
    post_type2 = filenames(fullfile(sub_dir, '*_rating02_19_dims*.mat'));
    post_type3 = filenames(fullfile(sub_dir, '*_rating03_fast*.mat'));
    
    survey2 = load(post_type3{1});
    
    for run_i = 1:numel(mr_run)
        clear data survey rating
        load(mr_run{run_i}); load(post_type2{run_i});
        for dd = 1:5 % valence, self, time, vivid, safe&threat
            % post-type2 (19 dim) "15 words" rating
            rating.post_type2_self(run_i,:) = survey.dat.response{1}(run_i,:); % self only
            rating.post_type2_pos(run_i,:) = survey.dat.response{9}(run_i,:); % positive only
            rating.post_type2_neg(run_i,:) = survey.dat.response{10}(run_i,:); % negative only
            rating.post_type2_vivid(run_i,:) = survey.dat.response{16}(run_i,:); % vivid only
            rating.post_type2_safe(run_i,:) = survey.dat.response{11}(run_i,:); % safe only
            rating.post_type2_threat(run_i,:) = survey.dat.response{12}(run_i,:); % threat only
            % post-type3 (5 dim) rating
            for w = 1:15
                rating.post_type3_all{dd}(run_i,w) = survey2.survey.dat{run_i,w}{dd}.rating;
            end
        end
    end
    
    for whole = 1:6
        
        if whole == 1
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{1}(:), rating.post_type2_pos(:), 'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{1}(:), rating.post_type2_pos(:));
            title(sub + " cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 val', 'FontSize', 15);
            ylabel("post2 " + dims{1+whole}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';
            hold on;
            
        elseif whole == 2
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{1}(:), -rating.post_type2_neg(:),'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{1}(:), -rating.post_type2_neg(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 val', 'FontSize', 15);
            ylabel("(-) post2 " + dims{1+whole}, 'FontSize', 15);
            
            set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';

            hold on;
            
        elseif whole == 3
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{whole+1}(:), rating.post_type2_vivid(:),'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{whole+1}(:), rating.post_type2_vivid(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel("post3 " + dims{1+whole}, 'FontSize', 15);
            ylabel("post2 " + dims{1+whole}, 'FontSize', 15);
            
            set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';

            hold on;
            
        elseif whole == 4
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{whole+1}(:), rating.post_type2_safe(:),'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{whole+1}(:), rating.post_type2_safe(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 safe&threat', 'FontSize', 15);
            ylabel("post2 " + dims{1+whole}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';

            hold on;
            
        elseif whole == 5
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{whole}(:), -rating.post_type2_threat(:), 'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{whole}(:), -rating.post_type2_threat(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 safe&threat', 'FontSize', 15);
            ylabel("(-) post2 " + dims{1+whole},'FontSize', 15);
            
                        set(gca, 'xlim', [-1.1, 1.1], 'ylim', [-1.1, 0.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';

            hold on;
            
        else
            subplot(2, 3, whole)
            scatter(rating.post_type3_all{2}(:), rating.post_type2_self(:),'filled', ...
                'MarkerEdgeAlpha',.8, 'MarkerFaceAlpha', .3)
            [R,p]=corrcoef(rating.post_type3_all{2}(:), rating.post_type2_self(:));
            title("cor=" + num2str(round(R(1,2),2)) + " p=" + num2str(round(p(1,2),4)), 'FontSize', 14);
            xlabel('post3 self', 'FontSize', 15);
            ylabel("post2 " + dims{1}, 'FontSize', 15);
            
                        set(gca, 'xlim', [-0.1, 1.1], 'ylim', [-0.1, 1.1]);

            l = lsline;
            l.LineWidth = 1; l.Color = 'r';

            hold on;
            saveas(gcf, fullfile(savedir, ["type3|type2 " + sub + '.png']))
            
        end
    end
    
end

