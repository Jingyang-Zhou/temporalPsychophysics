% tb_compute_wrapper

%% small spatial stimulus

% for hpc
addpath(genpath(fullfile(tb_rootPath)))
shCompileMex

%%

nRepeats = 100;

durs      = [2, 4, 8, 16, 32, 64];
%levels    = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.8, 1];
levels    =  logspace(log10(.01), log10(1), 20); 
sz1       = [40, 40];
accumWind = 'exponential';
rdRule    = 'maxRsp';

parfor k = 1 : nRepeats
    [ctr1{k}, coh1{k}] = tb_compute(durs, levels, sz1, accumWind, rdRule);
end

%% big spatial stimulus

sz2 = [100, 100];

parfor k = 1 : nRepeats
    [ctr2{k}, coh2{k}] = tb_compute(durs, levels, sz2, accumWind, rdRule);
end

%%  get output

saveLoc = fullfile(tb_rootPath, 'output');

save(fullfile(saveLoc, 'ctr1'), 'ctr1', '-v7.3')
save(fullfile(saveLoc, 'ctr2'),  'ctr2',  '-v7.3')
save(fullfile(saveLoc, 'coh1'), 'coh1',  '-v7.3')
save(fullfile(saveLoc, 'coh2'), 'coh2', '-v7.3')

%% analyze response

stimsz = {};

for k = 1 : 2
    stimsz{k}.ctr = zeros(length(levels), length(durs));
    stimsz{k}.coh = zeros(length(levels), length(durs));
end


for k = 1 : nRepeats
    stimsz{1}.ctr = stimsz{1}.ctr + ctr1{k}.mtdecVal;
    stimsz{1}.coh = stimsz{1}.coh + coh1{k}.mtdecVal;
    
    stimsz{2}.ctr = stimsz{2}.ctr + ctr2{k}.mtdecVal;
    stimsz{2}.coh = stimsz{2}.coh + coh2{k}.mtdecVal;
end

for k = 1 : 2
   stimsz{k}.ctrdec =  stimsz{k}.ctr/nRepeats;
   stimsz{k}.cohdec =  stimsz{k}.coh/nRepeats;
end

%% save output

saveLoc = fullfile(tb_rootPath, 'output');
save(fullfile(saveLoc, 'stimsz'), 'stimsz')

%%

% idx = [1, 3];
% figure
% for k = 1 : 2
%    subplot(2, 2, idx(k))
%    imagesc(stimsz{k}.ctrdec), caxis([0, 1])
%    
%    subplot(2, 2, idx(k) + 1)
%    imagesc(stimsz{k}.cohdec), caxis([0, 1])
% end

