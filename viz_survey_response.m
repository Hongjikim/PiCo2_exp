dims.name = {'자기 관련도', '긍정', '부정', '중요도', '관계성', '중심성', '과거', '현재', '미래', ...
    '빈도', '안전', '위협', '시각적 형상', '텍스트성', '강도/세기', '구체성/선명도', '추상정/관념성', ...
    '자발성', '목표'};
dims.msg = {'이 생각은 나와 관련이 있다.', '이 생각은 나에게 중요하다.', '이 생각은 나의 자아정체감에 핵심적이다', ...
    '이 생각은 다른 사람들과 관련이 있다.', '이 생각은 과거 시점과 관련이 있다.', '이 생각은 현재 시점과 관련이 있다.', ...
    '이 생각은 미래 시점과 관련이 있다.', '최근에 이 생각이 자주 들었다.', '이 생각에 대한 나의 감정은 긍정적이다.', ...
    '이 생각에 대한 나의 감정은 부정적이다.', '이 생각은 나에게 안전감을 준다.', '이 생각은 나에게 위협감을 준다.', ...
    '이 생각은 시각적 이미지로 떠오른다.', '이 생각은 글의 형태로 떠오른다.', '이 생각에 대한 나의 감정은..', ...
    '이 생각은 구체적이고 선명하다.', '이 생각은 추상적이고 관념적이다.', '이 생각은 자연스럽게 떠올랐다.', '이 생각은 특정 목표를 이루는 것과 관련이 있다.'};

clf;

survey_files = filenames(fullfile(pwd, '*survey*run*.mat'));
for run = 1:numel(survey_files)
    clear survey; dat{run} = load(survey_files{run});
end

for i = 1:numel(dat{1}.survey.dat.response)
    for run = 1:numel(survey_files)
        if ~isempty(dat{run}.survey.dat.response{i})
            subplot(7,6,2*i-1), plot(dat{run}.survey.dat.response{i}(run,:));
            title(dims.name{i}); hold on; box off;
            %             ylim([-0.1, 1.1]);
            set(gcf, 'color', 'white');
            subplot(7,6,2*i), histogram(dat{run}.survey.dat.response{i}(run,:),30);
            title(dims.name{i}); hold on;
        end
    end
end