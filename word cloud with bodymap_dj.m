%% Load Data
datdir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp/data';

sublist = dir(datdir);
subnames = {sublist.name}';
subnames = subnames(5:20); % select manually
subnames(7:14) = subnames(8:15); %7 out
subnames(14) = subnames(16); %15 out
subnames = subnames(1:14);

B = []; b = [];
B.bodymap = bodymap;
B.bodymap_binary = body_white_binary;
trials_num = 42;

W = [];
w = [];

ratings = cell(1,5); % valence, self, time, vividness, safety-threat
for dim_i = 1:5
    ratings{dim_i} = zeros(trials_num,numel(subjectdir));
end
words = cell(trials_num, numel(subjectdir));

j = 0;
for subject_i = 1:numel(subjectdir)
    
    fprintf('\n>>> working on sub_%02d >>>', subject_i)
    j=j+1;
    
    % load survey data of one subject    
    O = load(fullfile(datadir, 'pico_bodymap', subjectdir{subject_i}));
    original = O.survey.dat;
    original = reshape(original, trials_num, 1);
    
    % ratings
    for dim_i = 1:5
        for trial_i = 1:trials_num
            ratings{dim_i}(trial_i,j) = original{trial_i}{dim_i}.rating;
        end
    end
    
    % words
    original_word = O.survey.words;
    original_word = reshape(original_word', trials_num, 1);
    
    for trial_i = 1:trials_num
    words{trial_i, subject_i} = original_word{trial_i};
    end
    
    % word - related with safety-threat 
    w{j, 1} = subjectdir{subject_i};
    w{j, 2} = cell(trials_num,4);
    dim_st = ratings{1,5};
    dim_sf = ratings{1,2};
    dim_val = ratings{1,1};
    
    for trial_i2 = 1:trials_num
        w{j,2}{trial_i2,1} = words{trial_i2, subject_i};
        w{j,2}{trial_i2,2} = dim_st(trial_i2, subject_i);
        w{j,2}{trial_i2,3} = dim_sf(trial_i2, subject_i);
        w{j,2}{trial_i2,4} = dim_val(trial_i2, subject_i);
    end
    
    b{j,1} = subjectdir{subject_i}; % the first column of B is subnum
    % B{j,2} & B{j,3} = 42 x 2 cell
    b{j,2} = cell(trials_num,2);    % the first column of B{j,2} is for red.
                                    % the second column of B{j,2} is for blue.
    b{j,3} = cell(trials_num,2);                         
    for i = 1:trials_num
        b{j,2}{i,1} = original{i,1}{1,6}.rating_red;
        b{j,2}{i,2} = original{i,1}{1,6}.rating_blue;
    end
    
    % Subtract empty area, x-1534, y-262
    for i=1:trials_num
        if ~isempty(b{j,2}{i,1})    % rating red
            b{j,2}{i,1}(:,3) = b{j,2}{i,1}(:,1);
            b{j,2}{i,1}(:,1) = [];
            
            b{j,2}{i,1}(:,1) = b{j,2}{i,1}(:,1)-cut_edge(1);    % y-axis, length
            b{j,2}{i,1}(:,2) = b{j,2}{i,1}(:,2)-cut_edge(3);   % x-axis, width
        end
        
        if ~isempty(b{j,2}{i,2})    % rating blue
            b{j,2}{i,2}(:,3) = b{j,2}{i,2}(:,1);
            b{j,2}{i,2}(:,1) = [];
            
            b{j,2}{i,2}(:,1) = b{j,2}{i,2}(:,1)-cut_edge(1);    % y-axis
            b{j,2}{i,2}(:,2) = b{j,2}{i,2}(:,2)-cut_edge(3);   % x-axis
        end
    end
    
    % round up to integer
    for i =1:trials_num
        b{j,2}{i,1} = round(b{j,2}{i,1});
        b{j,2}{i,2} = round(b{j,2}{i,2});
    end
    
    % B{j,3} = 42 x 2 cell
    for i = 1:trials_num
        b{j,3}{i,1} = zeros(size(body_white_binary));     % 644 x 216 
        b{j,3}{i,2} = zeros(size(body_white_binary));     % 644 x 216
    end

    for i = 1:trials_num
        if ~isempty(b{j,2}{i,1})    % rating red
            for m = 1:size(b{j,2}{i,1},1)
                if b{j,2}{i,1}(m,1)>0 && b{j,2}{i,1}(m,2)>0 && b{j,2}{i,1}(m,1)<size(body_white_binary,1) && b{j,2}{i,1}(m,2)<size(body_white_binary,2)
                    b{j,3}{i,1}(b{j,2}{i,1}(m,1), b{j,2}{i,1}(m,2)) = 1;
                end
            end
        end
        
        if ~isempty(b{j,2}{i,2})    % rating blue
            for m = 1:size(b{j,2}{i,2},1)
                if b{j,2}{i,2}(m,1)>0 && b{j,2}{i,2}(m,2)>0 && b{j,2}{i,2}(m,1)<size(body_white_binary,1) && b{j,2}{i,2}(m,2)<size(body_white_binary,2)
                    b{j,3}{i,2}(b{j,2}{i,2}(m,1), b{j,2}{i,2}(m,2)) = 1;
                end
            end
        end
    end
end




%% Valence max/min words

val_word = [];
submax_val = max(dim_val,[],1);

word_num = 0
for subject_i2 = 1:subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,4}, submax_val(1,subject_i2))
            word_num = word_num +1;
            val_word{word_num,1} = w{subject_i2,2}{trial_i3,1};
        end
    end
end

% string
string_valmax = strings(word_num,1);
for i = 1: word_num
string_valmax(i,1) = val_word{i,1};
end


% bar plot
one = 0;
hist_valmax = strings(1);
for i = 1:word_num
    if ~isequal (sum(count(string_valmax, string_valmax(i))), 1)
       hist_valmax(i-one,1) = string_valmax(i);
       sum(count(string_valmax, string_valmax(i)))
    else one = one + 1;
    end
end    

hist_valmax = categorical(hist_valmax);
figure
histogram(hist_valmax, 'FaceColor', [252,141,89]./255);
% y axis 2-6.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_valmax.png'))




% word cloud
color = [252,141,89]./255;
string_valmax = categorical(string_valmax);
figure
wordcloud(string_valmax, 'HighlightColor', color);
title("Valence max Word Cloud")
saveas(gcf,fullfile(savedir,'Valence max Word Cloud.png'))




submin_val = min(dim_val, [], 1); % individual min rating
% figure;
% histogram(submin_st);
% saveas(gcf,fullfile(savedir,'minratings.png'))

word_num = 0;

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,4}, submin_val(1,subject_i2))
            word_num = word_num+1;
            val_word{word_num,2} = w{subject_i2,2}{trial_i3,1};
        end
    end
end


% word cloud
string_valmin = strings(word_num,1);
for i = 1: word_num
string_valmin(i,1) = val_word{i,2};
end



% bar plot
one = 0;
hist_valmin = strings(1);
for i = 1:word_num
    if ~isequal (sum(count(string_valmin, string_valmin(i))), 1)
       hist_valmin(i-one,1) = string_valmin(i);
       sum(count(string_valmin, string_valmin(i)))
    else one = one + 1;
    end
end    

hist_valmin = categorical(hist_valmin);
figure
histogram(hist_valmin, 'FaceColor', [145,191,219]./255);
% y axis 2-6.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_valmin.png'))



color = [145,191,219]./255;
string_valmin = categorical(string_valmin);
figure
wordcloud(string_valmin, 'HighlightColor', color);
title("Valence min Word Cloud")
saveas(gcf,fullfile(savedir,'Valence min Word Cloud.png'))



%% safety&threat max/min words

st_word = [];
submax_st = max(dim_st, [], 1); % individual max rating()
% figure;
% histogram(submax_st);
% saveas(gcf,fullfile(savedir,'maxratings.png'))

word_num = 0;

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,2}, submax_st(1,subject_i2))
            word_num = word_num +1;
            st_word{word_num,1} = w{subject_i2,2}{trial_i3,1};
        end
    end
end

% string
string_stmax = strings(word_num,1);
for i = 1: word_num
string_stmax(i,1) = st_word{i,1};
end


% bar plot
one = 0;
hist_stmax = strings(1);
for i = 1:word_num
    if ~isequal (sum(count(string_stmax, string_stmax(i))), 1)
       hist_stmax(i-one,1) = string_stmax(i);
       sum(count(string_stmax, string_stmax(i)))
    else one = one + 1;
    end
end    

hist_stmax = categorical(hist_stmax);
figure
histogram(hist_stmax, 'FaceColor', [161,215,106]./225);
% y axis 2-6.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_stmax.png'))




% word cloud
color = [0.4660 0.6740 0.1880];
string_stmax = categorical(string_stmax);
figure
wordcloud(string_stmax, 'HighlightColor', color);
title("Safe max Word Cloud")
saveas(gcf,fullfile(savedir,'Safe max Word Cloud.png'))




submin_st = min(dim_st, [], 1); % individual min rating
% figure;
% histogram(submin_st);
% saveas(gcf,fullfile(savedir,'minratings.png'))

word_num = 0;

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,2}, submin_st(1,subject_i2))
            word_num = word_num+1;
            st_word{word_num,2} = w{subject_i2,2}{trial_i3,1};
        end
    end
end


% word cloud
string_stmin = strings(word_num,1);
for i = 1: word_num
string_stmin(i,1) = st_word{i,2};
end



% bar plot
one = 0;
hist_stmin = strings(1);
for i = 1:word_num
    if ~isequal (sum(count(string_stmin, string_stmin(i))), 1)
       hist_stmin(i-one,1) = string_stmin(i);
       sum(count(string_stmin, string_stmin(i)))
    else one = one + 1;
    end
end    

hist_stmin = categorical(hist_stmin);
figure
histogram(hist_stmin, 'FaceColor', [233,163,201]./255);
% y axis 2-6.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_stmin.png'))



color = [0.9290 0.6940 0.1250];
string_stmin = categorical(string_stmin);
figure
wordcloud(string_stmin, 'HighlightColor', color);
title("Threat max Word Cloud")
saveas(gcf,fullfile(savedir,'Threat max Word Cloud.png'))

hist(string_stmin)


%% self max/min word

% self max

submax_sf = max(dim_sf, [], 1); % individual max rating()
% figure;
% histogram(submax_sf);
% saveas(gcf,fullfile(savedir,'maxratings_sf.png'))

word_num = 0;

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,3}, submax_sf(1,subject_i2))
            word_num = 1 + word_num;
            sf_word{word_num, 1} = w{subject_i2,2}{trial_i3,1};
        end
    end
end


% word cloud
string_sfmax = strings(word_num,1);
for i = 1: word_num
string_sfmax(i,1) = sf_word{i,1};
end


% bar plot
one = 0;
hist_sfmax = strings(1);
for i = 1:word_num
    if isequal (sum(count(string_sfmax, string_sfmax(i))), 1)
        one = one + 1;
    elseif isequal (sum(count(string_sfmax, string_sfmax(i))), 2)
        one = one + 1;
    else hist_sfmax(i-one,1) = string_sfmax(i);
    end
end    

hist_sfmax = categorical(hist_sfmax);
figure
histogram(hist_sfmax, 'FaceColor', [153,142,195]./225);
% y axis 3-7.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_sfmax.png'))


color = [0.3010 0.7450 0.9330];
string_sfmax = categorical(string_sfmax);
figure
wordcloud(string_sfmax, 'HighlightColor', color);
title("Self max Word Cloud")
saveas(gcf,fullfile(savedir,'Self max Word Cloud.png'))

hist(string_sfmax)


% self min

submin_sf = min(dim_sf, [], 1); % individual max rating()
% figure;
% histogram(submin_sf);
% saveas(gcf,fullfile(savedir,'minratings_sf.png'))

word_num = 0;

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(w{subject_i2,2}{trial_i3,3}, submin_sf(1,subject_i2))
            word_num = 1+word_num;
            sf_word{word_num,2} = w{subject_i2,2}{trial_i3,1};
        end
    end
end


% word cloud
string_sfmin = strings(word_num,1);
for i = 1: word_num
string_sfmin(i,1) = sf_word{i,2};
end



% bar plot
one = 0;
hist_sfmin = strings(1);
for i = 1:word_num
    if isequal (sum(count(string_sfmin, string_sfmin(i))), 1)
        one = one + 1;
    elseif isequal (sum(count(string_sfmin, string_sfmin(i))), 10)
        one = one + 1;
    elseif isequal (sum(count(string_sfmin, string_sfmin(i))), 26)
        one = one + 1;
    else  hist_sfmin(i-one,1) = string_sfmin(i);
        
    end
end

hist_sfmin = categorical(hist_sfmin);
figure
histogram(hist_sfmin, 'FaceColor', [241,163,64]./255);
% y axis 2-4.4, fontsize 20
saveas(gcf,fullfile(savedir,'hist_sfmin.png'))



color = [0 0.4470 0.7410];

one = 0;
newstring_sfmin = strings(1);
for i = 1:word_num
    if isequal (sum(count(string_sfmin, string_sfmin(i))), 10)
        one = one + 1;
    elseif isequal (sum(count(string_sfmin, string_sfmin(i))), 26)
        one = one + 1;
    else  newstring_sfmin(i-one,1) = string_sfmin(i);
    end
end

newstring_sfmin = categorical(newstring_sfmin);
figure
wordcloud(newstring_sfmin, 'HighlightColor', color);
title("Self min Word Cloud")
saveas(gcf,fullfile(savedir,'Self min Word Cloud.png'))

hist(string_sfmin)


savename = fullfile(savedir, 'pico_word_dongju.mat');
save(savename, 'words', 'W', 'st_word', 'sf_word');



%% trip / experiment (safety/threat max / min)


conv_circle =  [0 0 0 1 1 1 1 0 0 0;
                0 0 1 1 1 1 1 1 0 0;
                0 1 1 1 1 1 1 1 1 0;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                0 1 1 1 1 1 1 1 1 0;
                0 0 1 1 1 1 1 1 0 0;
                0 0 0 1 1 1 1 0 0 0];
            
            
            
mask = [body_white_binary == 1];
          
            

st_word_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'??'})
            st_word_max = st_word_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            st_word_max = st_word_max .* mask;
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

st_word_max2 = conv2(st_word_max, conv_circle, 'same');
clim1 = max([max(max(st_word_max2+double(bodymap==0))) abs(min(min(st_word_max2+double(bodymap==0))))]);
% st_word_max2 = st_word_max2 + clim1 * double(bodymap==0);
figure;
imagesc(st_word_max2+clim1 * double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'stmaxword_??.png'))



st_word_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    notmin = 0;
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'??'})
            st_word_min = st_word_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            st_word_min = st_word_min .* mask;
        end
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

st_word_min2 = conv2(st_word_min, conv_circle, 'same');
clim2 = max([max(max(st_word_min2+double(bodymap==0))) abs(min(min(st_word_min2+double(bodymap==0))))]);
st_word_min2 = st_word_min2 + clim2 * double(bodymap==0); 
figure;
imagesc((st_word_min2 + double(bodymap==0)), [-clim2 clim2]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'stminword_??.png'))


%% Valence max min


val_word_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'???'})
            val_word_max = val_word_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            val_word_max = val_word_max .* mask;
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

val_word_max2 = conv2(val_word_max, conv_circle, 'same');
clim3 = max([max(max(val_word_max2+double(bodymap==0))) abs(min(min(val_word_max2+double(bodymap==0))))]);
% st_word_max2 = st_word_max2 + clim1 * double(bodymap==0);
figure;
imagesc(val_word_max2+clim3 * double(bodymap==0), [-clim3 clim3]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'valmaxword_???.png'))



val_word_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    notmin = 0;
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'?? ????'})
            val_word_min = val_word_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            val_word_min = val_word_min .* mask;
        end
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

val_word_min2 = conv2(val_word_min, conv_circle, 'same');
clim4 = max([max(max(val_word_min2+double(bodymap==0))) abs(min(min(val_word_min2+double(bodymap==0))))]);
val_word_min2 = val_word_min2 + clim4 * double(bodymap==0); 
figure;
imagesc((val_word_min2 + double(bodymap==0)), [-clim4 clim4]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'valminword_?? ????.png'))






%% self max / min words - ?? / ????

conv_circle =  [0 0 0 1 1 1 1 0 0 0;
                0 0 1 1 1 1 1 1 0 0;
                0 1 1 1 1 1 1 1 1 0;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                0 1 1 1 1 1 1 1 1 0;
                0 0 1 1 1 1 1 1 0 0;
                0 0 0 1 1 1 1 0 0 0];
          
            

sf_word_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'????'})
            sf_word_max = sf_word_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            sf_word_max = sf_word_max .* mask;
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

sf_word_max2 = conv2(sf_word_max, conv_circle, 'same');
clim1 = max([max(max(sf_word_max2+double(bodymap==0))) abs(min(min(sf_word_max2+double(bodymap==0))))]);
sf_word_max2 = sf_word_max2 + clim1 * double(bodymap==0);
figure;
imagesc(sf_word_max2+double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'sfmaxword_????.png'))



sf_word_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if isequal(words(trial_i3,subject_i2), {'???'})
            sf_word_min = sf_word_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
            sf_word_min = sf_word_min .* mask;
        end
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

sf_word_min2 = conv2(sf_word_min, conv_circle, 'same');
clim2 = max([max(max(sf_word_min2+double(bodymap==0))) abs(min(min(sf_word_min2+double(bodymap==0))))]);
sf_word_min2 = sf_word_min2 + clim2 * double(bodymap==0); 
figure;
imagesc((sf_word_min2 + double(bodymap==0)), [-clim2 clim2]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'sfminword_???.png'))





%% Safety&threat max/min bodymap

% max
st_body_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,2} == submax_st(1,subject_i2)
            st_body_max = st_body_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

st_body_max2 = conv2(st_body_max, conv_circle, 'same');
clim1 = max([max(max(st_body_max2+double(bodymap==0))) abs(min(min(st_body_max2+double(bodymap==0))))]);
st_body_max2 = st_body_max2 + clim1 * double(bodymap==0);
figure;
imagesc(st_body_max2+double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'stmaxbody.png'))


%min

st_body_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    notmin = 0;
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,2} == submin_st(1,subject_i2)
            st_body_min = st_body_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2} ;
        end
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

st_body_min2 = conv2(st_body_min, conv_circle, 'same');
clim2 = max([max(max(st_body_min2+double(bodymap==0))) abs(min(min(st_body_min2+double(bodymap==0))))]);
st_body_min2 = st_body_min2 + clim2 * double(bodymap==0); 
figure;
imagesc((st_body_min2 + double(bodymap==0)), [-clim2 clim2]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'stminbody.png'))


%% Valence


% max
val_body_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,4} == submax_val(1,subject_i2)
            val_body_max = val_body_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

val_body_max2 = conv2(val_body_max, conv_circle, 'same');
clim1 = max([max(max(val_body_max2+double(bodymap==0))) abs(min(min(val_body_max2+double(bodymap==0))))]);
val_body_max2 = val_body_max2 + clim1 * double(bodymap==0);
figure;
imagesc(val_body_max2+double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'valmaxbody.png'))


%min

val_body_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    notmin = 0;
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,4} == submin_val(1,subject_i2)
            val_body_min = val_body_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2} ;
        end
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

val_body_min2 = conv2(val_body_min, conv_circle, 'same');
clim2 = max([max(max(val_body_min2+double(bodymap==0))) abs(min(min(val_body_min2+double(bodymap==0))))]);
val_body_min2 = val_body_min2 + clim2 * double(bodymap==0); 
figure;
imagesc((val_body_min2 + double(bodymap==0)), [-clim2 clim2]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'valminbody.png'))



%% self max


% max
sf_body_max = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,2} == max(max(dim_sf))
            sf_body_max = sf_body_max + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

sf_body_max2 = conv2(sf_body_max, conv_circle, 'same');
clim1 = max([max(max(sf_body_max2+double(bodymap==0))) abs(min(min(sf_body_max2+double(bodymap==0))))]);
sf_body_max2 = sf_body_max2 + clim1 * double(bodymap==0);
figure;
imagesc(sf_body_max2+double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'sfmaxbody.png'))



% min
sf_body_min = zeros(537, 180);

for subject_i2 = 1: subject_i
    for trial_i3 = 1:trials_num
        if w{subject_i2,2}{trial_i3,2} == min(min(dim_sf))
            sf_body_min = sf_body_min + b{subject_i2,3}{trial_i3,1} - b{subject_i2,3}{trial_i3,2};
        end 
    end
                         fprintf('\n>>> working on sub_%02d >>>', subject_i2)
end

sf_body_min2 = conv2(sf_body_min, conv_circle, 'same');
clim1 = max([max(max(sf_body_min2+double(bodymap==0))) abs(min(min(sf_body_min2+double(bodymap==0))))]);
sf_body_min2 = sf_body_min2 + clim1 * double(bodymap==0);
figure;
imagesc(sf_body_min2+double(bodymap==0), [-clim1 clim1]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
saveas(gcf,fullfile(savedir,'sfminbody.png'))




%% FIGURE : Accumulate
temp = [];
z = 1;
for i = 1:46
    for j = 1:42
        temp{1}(:,:,z) = b{i,3}{j,1};
        temp{2}(:,:,z) = b{i,3}{j,2};
        z = z+1;
    end
end

% red accumulate
body_data = sum(temp{1},3);
clim = max([max(max(body_data)) abs(min(min(body_data)))]);
body_data = body_data + clim * double(bodymap==0); 
figure;
imagesc(body_data, [-clim clim]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');

% blue accumulate
body_data = -sum(temp{2},3);
clim = max([max(max(body_data)) abs(min(min(body_data)))]);
body_data = body_data + clim * double(bodymap==0); 
figure;
imagesc(body_data, [-clim clim]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');


%% example
subj_i = 1;
trial_i = 20;
body_data = b{subj_i,3}{trial_i,1} + double(bodymap==0) - b{subj_i,3}{trial_i,2};
clim = max([max(max(body_data)) abs(min(min(body_data)))]);
figure;
imagesc(body_data, [-clim clim]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar
set(gcf, 'position', [721 119 247 506], 'color', 'w');
