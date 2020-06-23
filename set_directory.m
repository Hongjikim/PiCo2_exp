function basedir = set_directory(where)
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
        basedir = '/Users/hongji/Dropbox/github_hongji/PiCo2_exp';
        
    case 'dj_mac'
        % basedir = '/Users/hyebinkim/Dropbox/Cocoan lab/7T HCP/stimuli_candidates/git_7T_hcp_emotion';
        
    case 'WL01'
        basedir = 'C:\Users\Cocoanlab_WL01\Desktop\PiCo_exp-master';
end

addpath(genpath(basedir));

end