function basedir = pico2_set_directory(where)
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

end