

run = 1;

clear temp;
for i =1:2
    temp(i,:) = survey.dat.response{15+i}(run,:);
end

clf; plot(temp');

set(gca, 'XTick', 1:15, 'XTickLabel', survey.dat.whole_words(run,:), 'FontSize',  15); xtickangle(30);

legend