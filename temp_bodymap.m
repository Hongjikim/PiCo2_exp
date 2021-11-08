%% Original of body map 
bodymap = imread(fullfile(basedir, 'bodymap_screenshot.png'));    % screenshot of the real survey screen
% bodymap = imread(fullfile(datadir, 'bodymap_pico_1920_1080.png'));    % screenshot of the real survey screen
% bodymap = imread(fullfile(datadir, 'bodymap_pico_1600_900.png'));    % screenshot of the real survey screen
% imagesc(bodymap);

bodymap = bodymap(:,:,1);
bodymap([1:262 907:1080], :) = [];
bodymap(:, [1:1534 1751:1920]) = []; % bodymap = 644 X 216
body_white_binary = imresize(bodymap==255, 900/1080, 'nearest');
bodymap = imresize(bodymap, 900/1080, 'nearest');
% interpolation, fill the gaps btw datas in dot form so that they become
% linear. Kind of like smoothing

% figure; imagesc(body_white_binary)

screen_sz = [900 1600];
cut_edge = [262/1080 907/1080 1534/1920 1751/1920] .* reshape(repmat(screen_sz,2,1),1,4);
cut_edge = round(cut_edge);
% repmat : receive screen_sz as a input, aline it into 2 by 1 matrix

% bodymap = bodymap(1:screen_sz(1),1:screen_sz(2),1);
% bodymap([1:cut_edge(1) cut_edge(2):end], :) = [];
% bodymap(:, [1:cut_edge(3) cut_edge(4):end]) = []; % bodymap = 644 X 216
% [body_white(:,1), body_white(:,2)] = find(bodymap(:,:,1) == 255);
% body_white_binary = double(bodymap==255);
% imagesc(bodymap)

%% Load Data
filenames = dir(fullfile(datadir, 'pico_bodymap'));
filenames = {filenames.name};
subjectdir = filenames(contains(filenames','surveydata'))';
% filename 중 surverydata 포함된 것만 이름 보여줘
% contains의 결과가 logical, sum(contains(filenames','surveydata'))

B = []; b = [];
B.bodymap = bodymap;
B.bodymap_binary = body_white_binary;
trials_num = 42;

W = [];
w = [];

j = 0;
for subject_i = 1:numel(subjectdir)
    
    fprintf('\n>>> working on sub_%02d >>>', subject_i)
    j=j+1;
    
    % load survey data of one subject   
    O.survey = survey; % pico2
%     O = load(fullfile(datadir, 'pico_bodymap', subjectdir{subject_i}));
    original = O.survey.dat;
    original = reshape(original, trials_num, 1);
    
    % words
    original_word = O.survey.words;
    original_word = reshape(original_word', trials_num, 1);
    
    for trial_i = 1:trials_num
        all_sub_words{trial_i, subject_i} = original_word{trial_i};
    end
    
    b{j,1} = {'xx'};%subjectdir{subject_i}; % the first column of B is subnum
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



B.data = b;
savedir = '/Users/dongju/Downloads/summerintern_2020/scripts/Week4';
savename = fullfile(savedir, 'pico_body_dongju.mat');
save(savename, 'B', '-v7.3');

subject_id = b(:,1);
body_dat = b(:,3);
ratings_descript = {'valence', 'self', 'time', 'vividness', 'safety-threat'};
savename = fullfile(savedir, 'pico_dat_dongju.mat');
save(savename, 'subject_id', 'body_dat','ratings', 'ratings_descript', 'words', '-v7.3');
save(savename, 'ratings_descript', '-append');
save(savename, 'body_white_binary', '-append');

W.data = w;

%% Convolution 
% Magnify by using convolution
conv_circle =  [0 0 0 1 1 1 1 0 0 0;
                0 0 1 1 1 1 1 1 0 0;
                0 1 1 1 1 1 1 1 1 0;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1 1 1;
                0 1 1 1 1 1 1 1 1 0;
                0 0 1 1 1 1 1 1 0 0;
                0 0 0 1 1 1 1 0 0 0];
          
           
% example data 
body_data = body_dat{3}{1}; %body_dat{1}{5,1};
clim = max([max(max(body_data)) abs(min(min(body_data)))]);
% body_data = body_data + clim * body_white_binary; 

figure;
subplot(1,2,1);
imagesc(body_data, [-clim clim]);
c = [33,102,172;103,169,207;209,229,240;247,247,247;...
    253,219,199;239,138,98;178,24,43]/255;
colormap(c);
colorbar

subplot(1,2,2);
body_data_2 = conv2(body_data, conv_circle, 'same');
clim = max([max(max(body_data_2)) abs(min(min(body_data_2)))]);
imagesc(body_data_2, [-clim clim]);
set(gcf, 'position', [449 1 832 624], 'color', 'w');

basedir = '/Users/dongjupark/Dropbox/summerintern_2020/data';
dat = fmri_data(fullfile(basedir, 'fastmarker_self_unthresh.nii'));
dat = fmri_data(fullfile(basedir, 'fastmarker_self_unthresh_mpfc_only.nii'));
orthviews(dat);