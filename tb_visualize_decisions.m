%% visualize response

%% load results

fLoc = fullfile(tb_rootPath, 'output');
fname = 'dVal032217.mat';

a    = load(fullfile(fLoc, fname));
dVal = a.dVal;
stim = a.stim;

%% pre-defined variables

% needs to change here
durs   = stim.durs;
levels = stim.levels; 
sz     = stim.sz;

nLevels = length(levels);
nCtr    = length(durs);
nSz     = length(sz);
nRp     = length(dVal{1}.mtctr);

%% derived variables

dec = {};

for isz = 1 : nSz
    dec.ctr{isz} = zeros(nLevels, nCtr);
    dec.coh{isz} = zeros(nLevels, nCtr);
    
    for k = 1 : nRp
        dec.ctr{isz} = dec.ctr{isz} + dVal{isz}.mtctr{k};
        dec.coh{isz} = dec.coh{isz} + dVal{isz}.mtcoh{k};
    end
    dec.ctr{isz} = dec.ctr{isz}./nRp;
    dec.coh{isz} = dec.coh{isz}./nRp;
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