%% copy T1 files

basedir = '/Volumes/wissen/dropbox/data/PiCo2/imaging/dicom_from_scanner';
target_dir = '/Volumes/wissen/dropbox/data/PiCo2/imaging/T1_send';

manual_dir = filenames(fullfile(target_dir, '/*pdf'), 'char');
zip_dir = filenames(fullfile(target_dir, '/syngo*zip'), 'char');

for sub_i = 56:64  % 1-64 done
    
    sub_dir = filenames(fullfile(basedir, ['COCO0', num2str(sub_i, '%.2d'), '*']), 'char');
    
    hc_dir = filenames(fullfile(sub_dir, '/*/*HEAD_SCOUT_MPR*'), 'char');
    t1_dir = filenames(fullfile(sub_dir, '/*/T1_MP*'), 'char');
    
    [~, last, ~] = fileparts(sub_dir);
    dest_dir = fullfile(target_dir, last);
    mkdir(dest_dir);
    
    for i = 1:size(hc_dir,1)
        fprintf('\ncopying ...\nSource: %s\nDestination: %s\n', hc_dir(i,:), dest_dir);
        system(['cp -r ' deblank(hc_dir(i,:)) ' ' dest_dir]);
    end
    fprintf('\ncopying ...\nSource: %s\nDestination: %s\n', t1_dir, dest_dir);
    system(['cp -r ' t1_dir ' ' dest_dir]);
    
    system(['cp -r ' manual_dir ' ' dest_dir]);
    system(['cp -r ' zip_dir ' ' dest_dir]);
    
    zip(dest_dir, dest_dir);
%     rmdir(dest_dir, 's')
end

