% tb_compute_wrapper

%% small spatial stimulus

% for hpc
addpath(genpath(fullfile(tb_rootPath)))
shCompileMex

%%

nRepeats = 50;
sz1      = [40, 40];
sz2      = [70, 70];

durs      = [2, 4, 8, 16, 32, 64];
levels    = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.8, 1];
%levels    =  logspace(log10(.01), log10(1), 20); 

accumWind = 'exponential';
rdRule    = 'maxRsp';

%% small stimulus

%dVal1 = struct();
a = {};
b = {};
c = {};
d = {};

parfor k = 1 : nRepeats
    [ctr1, coh1] = tb_compute(durs, levels, sz1, accumWind, rdRule);
    
    a{k} = ctr1.mtdecVal;
    b{k} = coh1.mtdecVal;
    c{k} = ctr1.v1decVal;
    d{k} = coh1.v1decVal;
    
%     dVal1.mtctr{k} = ctr1.mtdecVal;
%     dVal1.mtcoh{k} = coh1.mtdecVal;
%     dVal1.v1ctr{k} = ctr1.v1decVal;
%     dVal1.v1coh{k} = coh1.v1decVal;
end

dVal{1}.mtctr = a;
dVal{1}.mtcoh = b;
dVal{1}.v1ctr = c;
dVal{1}.v1coh = d;


%% big spatial stimulus

%dVal2 = struct('mtctr', [], 'mtcoh', [], 'v1ctr', [], 'v1coh', []);

parfor k = 1 : nRepeats
    [ctr2, coh2] = tb_compute(durs, levels, sz2, accumWind, rdRule);
    
    a{k} = ctr2.mtdecVal;
    b{k} = coh2.mtdecVal;
    
    c{k} = ctr2.v1decVal;
    d{k} = coh2.v1decVal;
    
%     dVal2.mtctr{k} = ctr2.mtdecVal;
%     dVal2.mtcoh{k} = coh2.mtdecVal;
%     
%     dVal2.v1ctr{k} = ctr2.v1decVal;
%     dVal2.v1coh{k} = coh2.v1decVal;
end
dVal{2}.mtctr = a;
dVal{2}.mtcoh = b;
dVal{2}.v1ctr = c;
dVal{2}.v1coh = d;


%%  get output

saveLoc = fullfile(tb_rootPath, 'output');

save(fullfile(saveLoc, 'dVal'), 'dVal')

%% analyze response

% stimsz = {};
% 
% for k = 1 : 2
%     stimsz{k}.ctr = zeros(length(levels), length(durs));
%     stimsz{k}.coh = zeros(length(levels), length(durs));
% end
% 
% 
% for k = 1 : nRepeats
%     stimsz{1}.ctr = stimsz{1}.ctr + ctr1{k}.mtdecVal;
%     stimsz{1}.coh = stimsz{1}.coh + coh1{k}.mtdecVal;
%     
%     stimsz{2}.ctr = stimsz{2}.ctr + ctr2{k}.mtdecVal;
%     stimsz{2}.coh = stimsz{2}.coh + coh2{k}.mtdecVal;
% end
% 
% for k = 1 : 2
%    stimsz{k}.ctrdec =  stimsz{k}.ctr/nRepeats;
%    stimsz{k}.cohdec =  stimsz{k}.coh/nRepeats;
% end

%% save output

% saveLoc = fullfile(tb_rootPath, 'output');
% save(fullfile(saveLoc, 'stimsz'), 'stimsz')

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

