%%
dims.name = {'자기 관련도', '긍정', '부정', '중요도', '관계성', '중심성', '과거', '현재', '미래', ...
    '빈도', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', '추상정/관념성', ...
    '자발성', '목표'};
dims.msg = {'이 생각은 나와 관련이 있다.', '이 생각은 나에게 중요하다.', '이 생각은 나의 자아정체감에 핵심적이다', ...
    '이 생각은 다른 사람들과 관련이 있다.', '이 생각은 과거 시점과 관련이 있다.', '이 생각은 현재 시점과 관련이 있다.', ...
    '이 생각은 미래 시점과 관련이 있다.', '최근에 이 생각이 자주 들었다.', '이 생각에 대한 나의 감정은 긍정적이다.', ...
    '이 생각에 대한 나의 감정은 부정적이다.', '이 생각은 나에게 안전감을 준다.', '이 생각은 나에게 위협감을 준다.', ...
    '이 생각은 시각적 이미지로 떠오른다.', '이 생각은 글의 형태로 떠오른다.', '이 생각에 대한 나의 감정은..', ...
    '이 생각은 구체적이고 선명하다.', '이 생각은 추상적이고 관념적이다.', '이 생각은 자연스럽게 떠올랐다.', '이 생각은 특정 목표를 이루는 것과 관련이 있다.'};

anchor = {'매우\n그렇다', '전혀\n아니다', '매우 강함', '매우 약함'};

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
practice_prompt{1} = double('지금부터 스캐너에서 말한 단어의 예시가 화면 위쪽에 순서대로 등장할 것입니다.');
practice_prompt{2} = double('단어와 함께 몇가지 질문에 나타날텐데');
practice_prompt{3} = double('각 단어를 떠올린 맥락을 고려하여 각 질문에 솔직하게 응답해주세요.');
practice_prompt{4} = double('여기서 맥락이란 본인이 그 단어를 떠올렸을 당시에 느꼈던 개인적인 감정 혹은 생각을 의미합니다.');
practice_prompt{5} = double('혹시 이 단어를 떠올렸을 때의 맥락이 기억나지 않으면 현재 느껴지는 개인적인 감정 혹은 생각에 대해 답해주세요.');
practice_prompt{6} = double('한번 클릭한 것은 되돌릴 수 없으니 신중하게 클릭해주세요.');
practice_prompt{7} = double('\n잠시 연습을 해보겠습니다. 시작하려면 스페이스를 눌러주세요.');

ready_prompt{1} = double('지금부터 스캐너에서 말한 각 단어가 화면 위쪽에 순서대로 등장할 것입니다.');
ready_prompt{2} = double('단어와 함께 몇가지 질문이 나타날텐데');
ready_prompt{3} = double('각 단어를 떠올린 맥락을 고려하여 각 질문에 솔직하게 응답해주세요.');
ready_prompt{4} = double('여기서 맥락이란 본인이 그 단어를 떠올렸을 당시에 느꼈던 개인적인 감정 혹은 생각을 의미합니다.');
ready_prompt{5} = double('혹시 이 단어를 떠올렸을 때의 맥락이 기억나지 않으면 현재 느껴지는 개인적인 감정 혹은 생각에 대해 답해주세요..');
ready_prompt{6} = double('한번 클릭한 것은 되돌릴 수 없으니 신중하게 클릭해주세요');
ready_prompt{7} = double(' ');
ready_prompt{8} = double('설문은 총 6개의 세트로 이루어져 있으며 세트가 끝날 때마다 휴식을 취하셔도 좋습니다.');
ready_prompt{9} = double('약 2시간 정도 예상되는 설문이므로 마지막까지 집중해서 응답해주시기를 바랍니다.');
ready_prompt{10} = double('\n시작하려면 스페이스를 눌러주세요.');


practice_end_prompt = double('잘하셨습니다. 질문이 있으신가요?\n\n시작할 준비가 되셨으면 스페이스를 눌러주세요.');
run_end_prompt = double('잘하셨습니다. 잠시 휴식을 가지셔도 됩니다.\n다음 세트를 시작할 준비가 되면 스페이스를 눌러주세요.');

exp_end_prompt = double('설문을 모두 마치셨습니다. 감사합니다!');

 pw = {'커피', '카페'};

save('promt_kor.mat', 'practice_prompt', 'ready_prompt', 'practice_end_prompt', ...
    'run_end_prompt', 'exp_end_prompt', 'pw');

%%
title={'','', '','', '', '';
    '부정', '전혀 나와\n관련이 없음', '과거', '전혀 생생하지 않음', '위협', '';
    '중립', '', '현재', '', '중립', '';
    '긍정','나와 관련이\n매우 많음', '미래','매우 생생함','안전','';
    '단어에서 느껴지는 감정', '단어가 자신과 관련이 있는 정도', '단어가 가장 관련이 있는 자신의 시간', ...
    '단어가 어떤 상황이나 장면을\n얼마나 생생하게 떠올리게 하는지', '단어가 안전 또는 위협을\n의미하거나 느끼게 하는지', '';
    '그 생각이 일으킨 감정은?', '그 생각이 나와 관련이 있는 정도는?', '그 생각이 가장 관련이 있는 자신의 시간?', ...
    '그 생각이 어떤 상황이나 장면을\n생생하게 떠올리게 했나요?', '그 생각이 안전 또는 위협을\n의미하거나 느끼게 했나요?',''};

body_prompt = {'해당 단어를 떠올릴 때 활발해지거나 빨라지는 몸의 부분은 빨간색으로,'
    '활동이 약해지거나 느려지는 것 같은 몸의 부분은 파란색으로 색칠해주세요.';
    '한 단어에 대해 빨간색과 파란색 모두 칠할 수 있고 한번 칠해진 곳은 지울 수 없습니다.';
    '몸 밖에 칠해진 것은 분석에 사용되지 않으니 몸 안쪽에 칠해주세요.';
    '색칠을 하고자 하는 영역의 빈 공간을 모두 채워주세요.';
    '버튼 r 을 누르면 빨간색으로, b 를 누르면 파란색으로 칠할 수 있습니다.';
    '\n다 칠하셨으면 키보드 a을 눌러주세요.'};

save('promt_kor2.mat', 'title', 'body_prompt');

%% for word segmentation (post-rating type1)

input_msg.a = '** 구분선을 더하고 싶으면 a를, 빼고 싶으면 d를 눌러주세요. (끝내고 싶을 땐 z를 눌러주세요.):';
input_msg.b = '** 잘못 누르신 것 같아요. 구분선을 더하고 싶으면 a를, 빼고 싶으면 d를 눌러주세요:';
input_msg.c = '** 몇 번째 단어 뒤에 구분선을 더하고 싶으신가요?: (1-15)';

save('promt_kor3_event_seg.mat', 'input_msg')