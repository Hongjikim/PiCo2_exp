rng('shuffle')

aa = {2:3, 7:9, 11:12, 13:14, 16:17, ...
    1, 4, 5, 6, 10, 15, 18, 19};

idx = randperm(length(aa));
aa = aa(idx);

for ii = 1:length(aa)    
    aa{ii} = aa{ii}(randperm(length(aa{ii})));
end

res=cat(2,aa{:});
