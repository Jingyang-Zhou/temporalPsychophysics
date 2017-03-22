%% visualize response

%% load results

fLoc = fullfile(tb_rootPath, 'output');
fname = 'dVal032217.mat';

a    = load(fullfile(fLoc, fname));
dVal = a.dVal;
stim = a.stim;

%% pre-defined variables

% needs to change here
durs   = stim.durs;   nDurs    = length(durs);
levels = stim.levels; nLevels = length(levels);
sz     = stim.sz;     nSz     = length(sz);

nRp     = length(dVal{1}.mtctr);

%% derived variables

dec = {};

for isz = 1 : nSz
    dec.ctr{isz} = zeros(nLevels, nDurs);
    dec.coh{isz} = zeros(nLevels, nDurs);
    
    for k = 1 : nRp
        dec.ctr{isz} = dec.ctr{isz} + dVal{isz}.mtctr{k};
        dec.coh{isz} = dec.coh{isz} + dVal{isz}.mtcoh{k};
    end
    dec.ctr{isz} = dec.ctr{isz}./nRp;
    dec.coh{isz} = dec.coh{isz}./nRp;
end

%% fit Weibull to each sz x duration condition

psychometric = {};

for isz = 1 : nSz
    for iDur = 1: nDurs
        
    end
end


%% visualize - plot correctness at each condition

figure (1), clf,% colormap gray

for k = 1 : nSz
    subplot(2, nSz, k), 
    imagesc(dec.ctr{k}), caxis([0, 1]), set(gca, 'xticklabel', '', 'yticklabel', '')
    subplot(2, nSz, k + nSz), 
    imagesc(dec.coh{k}), caxis([0, 1]), set(gca, 'xticklabel', '', 'yticklabel', '')
    
    if k == 4, 
        subplot(2, nSz, k), title('contrast'), xlabel('duration'), ylabel('contrast')
        subplot(2, nSz, k + nSz), title('coherence'), xlabel('duration'), ylabel('coherence')
    end
end

%% make psychometric function at each duration
% cols = gray(nDurs + 1);
% iSz   = 7;
% 
% figure (2), clf
% for k = 1 : nDurs
%     subplot(1, 2, 1)
%     semilogx(levels, dec.ctr{iSz}(:, k), 'o-', 'color', cols(k,  :)), hold on, box off
%     subplot(1, 2, 2)
%     semilogx(levels, dec.coh{iSz}(:, k), 'o-', 'color', cols(k,  :)), hold on, box off
% end