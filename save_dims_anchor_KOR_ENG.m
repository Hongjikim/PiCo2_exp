%%
dims.name = {'�ڱ� ���õ�', '����', '����', '�߿䵵', '���輺', '�߽ɼ�', '����', '����', '�̷�', ...
    '��', '����', '����', '�ð��� ����', '�ؽ�Ʈ��', '����/����', '��ü��/����', '�߻���/���伺', ...
    '�ڹ߼�', '��ǥ'};
dims.msg = {'�� ������ ���� ������ �ִ�.', '�� ������ ������ �߿��ϴ�.', '�� ������ ���� �ھ���ü���� �ٽ����̴�', ...
    '�� ������ �ٸ� ������ ������ �ִ�.', '�� ������ ���� ������ ������ �ִ�.', '�� ������ ���� ������ ������ �ִ�.', ...
    '�� ������ �̷� ������ ������ �ִ�.', '�ֱٿ� �� ������ ���� �����.', '�� ������ ���� ���� ������ �������̴�.', ...
    '�� ������ ���� ���� ������ �������̴�.', '�� ������ ������ �������� �ش�.', '�� ������ ������ �������� �ش�.', ...
    '�� ������ �ð��� �̹����� ��������.', '�� ������ ���� ���·� ��������.', '�� ������ ���� ���� ������..', ...
    '�� ������ ��ü���̰� �����ϴ�.', '�� ������ �߻����̰� �������̴�.', '�� ������ �ڿ������� ���ö���.', '�� ������ Ư�� ��ǥ�� �̷�� �Ͱ� ������ �ִ�.'};

anchor = {'�ſ�\n�׷���', '����\n�ƴϴ�', '�ſ� ����', '�ſ� ����'};

save('dims_anchor_korean.mat', 'dims', 'anchor');

%%
dims.name = {'self-relevance', 'importance/value', 'centrality', 'social', 'past', 'present', 'future' ...
    'frequency', 'positive', 'negetive', 'safe', 'threat', 'imagery', 'word', 'intensity', 'detail(vivid)', ...
    'abstract', 'spontaneous', 'deliberate(goal)'};
dims.msg = { 'I consider this thought to be highly self-relevant.', ...
    'The topic of this thought is of great value or importance to me.', ...
'This thought contributes to my sense of self-identity.', ...
'My thoughts involved other people.', 'My thoughts involved past events.', ...
'My thoughts involved present events.', 'My thoughts involved future events.', ...
'Lately, it seems that this thought has been on my mind a great deal.', ...
'My own emotions pertaining to this thought are positive.', ...
'My own emotions pertaining to this thought are negative.', ...
'My own emotions pertaining to this thought are safe.', ...
'My own emotions pertaining to this thought are dangerous.', ...
'My thoughts were in the form of images.', 'My thoughts were in the form of words.', ...
'The intensity of my emotions pertaining to this thought are ...', ...
'My thoughts were specific and detailed or vivid.', ...
'My thoughts were abstract and conceptual.', 'My thoughts were spontaneous.', ...
'This thought involves/involved reaching a particular goal of mine.'};

anchor = {'Very\nmuch', 'Not\nat all', 'Very\nstrong', 'Very\nweak'};

save('dims_anchor_english.mat', 'dims', 'anchor');

%% promt
%% PROMPT SETUP:
%% promt
%% PROMPT SETUP:
practice_prompt{1} = double('���ݺ��� ��ĳ�ʿ��� ���� �ܾ��� ���ð� ȭ�� ���ʿ� ������� ������ ���Դϴ�.');
practice_prompt{2} = double('�ܾ�� �Բ� ��� ������ ��Ÿ���ٵ�');
practice_prompt{3} = double('�� �ܾ ���ø� �ƶ��� ����Ͽ� �� ������ �����ϰ� �������ּ���.');
practice_prompt{4} = double('���⼭ �ƶ��̶� ������ �� �ܾ ���÷��� ��ÿ� ������ �������� ���� Ȥ�� ������ �ǹ��մϴ�.');
practice_prompt{5} = double('Ȥ�� �� �ܾ ���÷��� ���� �ƶ��� ��ﳪ�� ������ ���� �������� �������� ���� Ȥ�� ������ ���� �����ּ���.');
practice_prompt{6} = double('�ѹ� Ŭ���� ���� �ǵ��� �� ������ �����ϰ� Ŭ�����ּ���.');
practice_prompt{7} = double('\n��� ������ �غ��ڽ��ϴ�. �����Ϸ��� �����̽��� �����ּ���.');

ready_prompt{1} = double('���ݺ��� ��ĳ�ʿ��� ���� �� �ܾ ȭ�� ���ʿ� ������� ������ ���Դϴ�.');
ready_prompt{2} = double('�ܾ�� �Բ� ��� ������ ��Ÿ���ٵ�');
ready_prompt{3} = double('�� �ܾ ���ø� �ƶ��� ����Ͽ� �� ������ �����ϰ� �������ּ���.');
ready_prompt{4} = double('���⼭ �ƶ��̶� ������ �� �ܾ ���÷��� ��ÿ� ������ �������� ���� Ȥ�� ������ �ǹ��մϴ�.');
ready_prompt{5} = double('Ȥ�� �� �ܾ ���÷��� ���� �ƶ��� ��ﳪ�� ������ ���� �������� �������� ���� Ȥ�� ������ ���� �����ּ���..');
ready_prompt{6} = double('�ѹ� Ŭ���� ���� �ǵ��� �� ������ �����ϰ� Ŭ�����ּ���');
ready_prompt{7} = double(' ');
ready_prompt{8} = double('������ �� 6���� ��Ʈ�� �̷���� ������ ��Ʈ�� ���� ������ �޽��� ���ϼŵ� �����ϴ�.');
ready_prompt{9} = double('�� 2�ð� ���� ����Ǵ� �����̹Ƿ� ���������� �����ؼ� �������ֽñ⸦ �ٶ��ϴ�.');
ready_prompt{10} = double('\n�����Ϸ��� �����̽��� �����ּ���.');


practice_end_prompt = double('���ϼ̽��ϴ�. ������ �����Ű���?\n\n������ �غ� �Ǽ����� �����̽��� �����ּ���.');
run_end_prompt = double('���ϼ̽��ϴ�. ��� �޽��� �����ŵ� �˴ϴ�.\n���� ��Ʈ�� ������ �غ� �Ǹ� �����̽��� �����ּ���.');

exp_end_prompt = double('������ ��� ��ġ�̽��ϴ�. �����մϴ�!');

 pw = {'Ŀ��', 'ī��'};

save('promt_kor.mat', 'practice_prompt', 'ready_prompt', 'practice_end_prompt', ...
    'run_end_prompt', 'exp_end_prompt', 'pw');

%%
title={'','', '','', '', '';
    '����', '���� ����\n������ ����', '����', '���� �������� ����', '����', '';
    '�߸�', '', '����', '', '�߸�', '';
    '����','���� ������\n�ſ� ����', '�̷�','�ſ� ������','����','';
    '�ܾ�� �������� ����', '�ܾ �ڽŰ� ������ �ִ� ����', '�ܾ ���� ������ �ִ� �ڽ��� �ð�', ...
    '�ܾ � ��Ȳ�̳� �����\n�󸶳� �����ϰ� ���ø��� �ϴ���', '�ܾ ���� �Ǵ� ������\n�ǹ��ϰų� ������ �ϴ���', '';
    '�� ������ ����Ų ������?', '�� ������ ���� ������ �ִ� ������?', '�� ������ ���� ������ �ִ� �ڽ��� �ð�?', ...
    '�� ������ � ��Ȳ�̳� �����\n�����ϰ� ���ø��� �߳���?', '�� ������ ���� �Ǵ� ������\n�ǹ��ϰų� ������ �߳���?',''};

body_prompt = {'�ش� �ܾ ���ø� �� Ȱ�������ų� �������� ���� �κ��� ����������,'
    'Ȱ���� �������ų� �������� �� ���� ���� �κ��� �Ķ������� ��ĥ���ּ���.';
    '�� �ܾ ���� �������� �Ķ��� ��� ĥ�� �� �ְ� �ѹ� ĥ���� ���� ���� �� �����ϴ�.';
    '�� �ۿ� ĥ���� ���� �м��� ������ ������ �� ���ʿ� ĥ���ּ���.';
    '��ĥ�� �ϰ��� �ϴ� ������ �� ������ ��� ä���ּ���.';
    '��ư r �� ������ ����������, b �� ������ �Ķ������� ĥ�� �� �ֽ��ϴ�.';
    '\n�� ĥ�ϼ����� Ű���� a�� �����ּ���.'};

save('promt_kor2.mat', 'title', 'body_prompt');

%% for word segmentation (post-rating type1)

input_msg.a = '** ���м��� ���ϰ� ������ a��, ���� ������ d�� �����ּ���. (������ ���� �� z�� �����ּ���.):';
input_msg.b = '** �߸� ������ �� ���ƿ�. ���м��� ���ϰ� ������ a��, ���� ������ d�� �����ּ���:';
input_msg.c = '** �� ��° �ܾ� �ڿ� ���м��� ���ϰ� �����Ű���?: (1-15)';

save('promt_kor3_event_seg.mat', 'input_msg')