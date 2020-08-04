function [basedir, sid, subject_dir] = pico2_directory_sub_info(where)
%
% It sets up the essential directories according to where you are.
% and in case of server, it adds paths
%
%  ::: example :::
%   basedir = set_directory('hj_mac');
%
%  ::: options :::
%             'hj_mac'
%             'dj_mac'
%             'WL01'
%
%%
switch where
    case 'hj_mac'
        basedir = '/Users/hongji/Dropbox/PiCo2_sync/PiCo2_exp';
        
    case 'dj_mac'
        basedir = '/Users/dongjupark/Dropbox/PiCo2_sync/PiCo2_exp';
        
    case 'WL01'
        basedir = '/Users/Cocoanlab_WL01/Dropbox/PiCo2_sync/PiCo2_exp';
        
    case 'BE_imac'
        basedir = '/Users/cocoanlab/Dropbox/PiCo2_sync/PiCo2_exp'
        
    case 'int01' % interview room 01 in CNIR
        basedir = '/Users/cocoan/Dropbox/PiCo2_sync/PiCo2_exp';
end

addpath(genpath(basedir));

sid = input('Subject ID? (e.g., coco001_khj): ', 's');
sid(isspace(sid)) = []; % remove every blank

datdir = fullfile(basedir, 'data');
subject_dir = fullfile(datdir, sid);

if exist(subject_dir, 'dir') == 0 % no subject dir
    fprintf(['\n ** no existing directory: ', sid, ' **']);
    cont_or_not = input(['\n Do you want to make new subject directory?', ...
        '\n1: Yes, make directory.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Break.')
    elseif cont_or_not == 1
        mkdir(subject_dir);
    end
end


end