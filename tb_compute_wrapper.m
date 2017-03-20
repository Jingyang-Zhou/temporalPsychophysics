% tb_compute_wrapper

%% small spatial stimulus

addpath(genpath(fullfile(tb_rootPath, 'code')))

nRepeats = 100;

durs      = [2, 4, 8, 16, 32, 64];
levels    = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.8, 1];
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

save(fullfile(saveLoc, 'sz2'), 'ctr1', 'ctr2', 'coh1', 'coh2')

%% analyze response

stimsz = {};

for k = 1 : 2
    stimsz{k}.ctr = zeros(length(levels), length(durs));
    stimsz{k}.coh = zeros(length(levels), length(durs));
end

for k = 1 : nRepeats
    stimsz{1}.ctr = stimsz{1}.ctr + ctr1{k};
end

% 
% for k = 1 : nRepeats
%    sza.ctr  = sza.ctr + ctr1{k}.mtdecVal;
%    sza.coh  = sza.coh + coh1{k}.mtdecVal;
%    
%    szb.ctr = szb.ctr +ctr2{k}.mtdecVal;
%    szb.coh = szb.coh +coh2{k}.mtdecVal;
% end
% 
% sza.ctr = sza.ctr./nRepeats;
% sza.coh = sza.coh./nRepeats;
% 
% szb.ctr = szb.ctr./nRepeats;
% szb.coh = szb.coh./nRepeats;
% 
% figure (1), clf
% 
% subplot(2, 2, 1)
% imagesc(sza.ctr), caxis([0, 1])
% subplot(2, 2, 2)
% imagesc(sza.coh), caxis([0, 1])
% 
% subplot(2, 2, 3)
% imagesc(szb.ctr), caxis([0, 1])
% subplot(2, 2, 4)
% imagesc(szb.coh), caxis([0, 1])


