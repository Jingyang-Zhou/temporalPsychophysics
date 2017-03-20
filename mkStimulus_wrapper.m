% mkStimulus wrapper

nStim = 7;

duration = round(logspace(2.1, 3.2, nStim))./1000; % duration, in unit of second
contrast = round(logspace(0, 2, nStim)./100, 2); % contrast, between 0 and 1
coherence = round(logspace(0, 2, nStim));     % coherence, between 1 and 100

dfcontrast  = 1;
dfcoherence = 100;

figure (1), clf
plot(duration, 'o')

%% generate varying contrast stimuli

for k = 1 : nStim % vary duration
    for k1 = 1 : nStim % vary contrast
       ctrStim{k, k1}= mkStimulus(duration(k), contrast(k1), dfcoherence);
    end
end

%% generate varying conherence stimulus

for k = 1 : nStim % vary duration
    for k1 = 1 : nStim % vary coherence
       cohStim{k, k1}= mkStimulus(duration(k), dfcontrast, coherence(k1));
    end
end

%% save stimulus

param = [];
param.duration = duration;
param.contrast = contrast;
param.coherence = coherence;

saveLoc = fullfile(tBevRootPath, 'output');

save(fullfile(saveLoc, 'CtrCohStim'), 'ctrStim', 'cohStim', 'param')

