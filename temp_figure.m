for run = 1:numel(survey_files)
    if sum(strcmp(fields(dat{run}.survey), 'dat')) == 1
        
        for i = 1:numel(dat{run}.survey.dat.response)
            if run ==1
                dat_cat{i} = dat{run}.survey.dat.response{i}(run,:);
            else
                dat_cat{i} = [dat_cat{i}, dat{run}.survey.dat.response{i}(run,:)];
            end
        end
    end
end

%%

mycolormap = [165,0,38; 215,48,39; 244,109,67; 253,174,97;
    254,224,144; 255,255,191; 224,243,248; 171,217,233;
    116,173,209; 69,117,180; 49,54,149]/255;
mycolormap = flip(mycolormap);

cc = [3, 8, 11, 2];
close all;
c= 0 ;
lw = 2.5;

dims.name{1} = '자기 관련도'; dims.name{8} = '빈도';  dims.name{9} = '긍정성'; dims.name{10} = '부정성';

for i = [1, 8:10]%1:19
    
%     subplot(5,4,i)
c = c+1; subplot(2,2,c)
    p = plot(dat_cat{i});
    p.LineWidth = lw;
    p.Color = mycolormap(cc(c),:);
    title(dims.name{i}, 'FontSize', 30); hold on; box off;
    %             ylim([-0.1, 1.1]);
    set(gcf, 'color', 'white');
    set(gca, 'tickdir', 'out', 'ticklength', [.02 .02], 'linewidth', lw);
    set(gca, 'FontSize', 20)

    %                 subplot(7,6,2*i), histogram(dat{run}.survey.dat.response{i}(run,:),30);
    %                 title(dims.name{i}, 'FontSize', 15); hold on;
    
%     xl = line([15, 15, 30, 30, 45, 45, 60, 60], [0, 1, 0, 1, 0, 1, 0, 1]); xl.Color = [1 1 1]; xl.LineWidth = 2;
x = 15:15:60;
y = [0 1];
for k = 1:4
    l=line(repmat(x(k),1,2),y);
    l.Color = [0.3 0 0 0.3]; l.LineWidth = 2.5; % l.LineStyle = '--';
end

end

%%
target{1} = 1;
target{2} = 2:3;
target{3} = 4;
target{4} = 5:7;
target{5} = 8;
target{6} = 9:10;
target{7} = 11:12;
target{8} = 13:14;
target{9} = 15;
target{10} = 16:17;
target{11} = 18:19;


for j = 1:11
    subplot(3,4,j)
    for t = 1:numel(target{j})
        plot(dat_cat{target{j}(t)});
        hold on;
    end
end