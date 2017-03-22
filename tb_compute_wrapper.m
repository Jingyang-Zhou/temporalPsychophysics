% tb_compute_wrapper

%% small spatial stimulus

% for hpc
addpath(genpath(fullfile(tb_rootPath)))
%shCompileMex

%%

nRepeats = 50;
sz      = [40, 50, 60, 70, 80, 90, 100];
% sz1      = [40, 40];
% sz2      = [70, 70];

durs      = [2, 4, 8, 16, 32, 64];
%levels    = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.8, 1];
levels    =  logspace(log10(.01), log10(1), 20); 

accumWind = 'exponential';
rdRule    = 'maxRsp';

%% compute

for isz = 1 : length(sz)
    parfor k = 1 : nRepeats
        [ctr, coh] = tb_compute(durs, levels, [sz(isz), sz(isz)], accumWind, rdRule);
        
        a{k} = ctr.mtdecVal;
        b{k} = coh.mtdecVal;
        c{k} = ctr.v1decVal;
        d{k} = coh.v1decVal;
        
    end
    dVal{isz}.mtctr = a;
    dVal{isz}.mtcoh = b;
    
    dVal{isz}.v1ctr = c;
    dVal{isz}.v1coh = d;
end

%% small stimulus

% %dVal1 = struct();
% a = {};
% b = {};
% c = {};
% d = {};
% 
% parfor k = 1 : nRepeats
%     [ctr1, coh1] = tb_compute(durs, levels, sz1, accumWind, rdRule);
%     
%     a{k} = ctr1.mtdecVal;
%     b{k} = coh1.mtdecVal;
%     c{k} = ctr1.v1decVal;
%     d{k} = coh1.v1decVal;
%     
% %     dVal1.mtctr{k} = ctr1.mtdecVal;
% %     dVal1.mtcoh{k} = coh1.mtdecVal;
% %     dVal1.v1ctr{k} = ctr1.v1decVal;
% %     dVal1.v1coh{k} = coh1.v1decVal;
% end
% 
% dVal{1}.mtctr = a;
% dVal{1}.mtcoh = b;
% dVal{1}.v1ctr = c;
% dVal{1}.v1coh = d;


%% big spatial stimulus



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
%     stimsz{1}.ctr = stimsz{1}.ctr + dVal{1}.mtctr{k};
%     stimsz{1}.coh = stimsz{1}.coh + dVal{1}.mtcoh{k};
%     
%     stimsz{2}.ctr = stimsz{2}.ctr + dVal{2}.mtctr{k};
%     stimsz{2}.coh = stimsz{2}.coh + dVal{2}.mtcoh{k};
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

