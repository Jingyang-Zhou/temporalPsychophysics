%% visualize response

%% load results

fLoc = fullfile(tb_rootPath, 'output');
fname = 'dVal.mat';

a    = load(fullfile(fLoc, fname));
dVal = a.dVal;

%% pre-defined variables

% needs to change here
durs      = [2, 4, 8, 16, 32, 64];
levels    =  logspace(log10(.01), log10(1), 20); 

%% derived variables

nLevels = size(dVal{1}.mtctr{1}, 1);
nCtr    = size(dVal{1}.mtctr{1}, 2);
nSz     = size(dVal, 2);
nRp     = length(dVal{1}.mtctr);

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

%% visualize

figure (1), clf,% colormap gray

for k = 1 : nSz
    subplot(2, 5, k), imagesc(dec.ctr{k}), caxis([0, 1]), set(gca, 'xticklabel', '', 'yticklabel', '')
    subplot(2, 5, k + 5), imagesc(dec.coh{k}), caxis([0, 1]), set(gca, 'xticklabel', '', 'yticklabel', '')
    
    if k == 3, 
        subplot(2, 5, k), title('contrast'), xlabel('duration'), ylabel('contrast')
        subplot(2, 5, k + 5), title('coherence'), xlabel('duration'), ylabel('coherence')
    end
end