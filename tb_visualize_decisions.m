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
    
    dec.ctrNCorrect{isz} = dec.ctr{isz};
    dec.cohNCorrect{isz} = dec.coh{isz};
    
    dec.ctr{isz} = dec.ctr{isz}./nRp;
    dec.coh{isz} = dec.coh{isz}./nRp;
end

%% fit Weibull to each sz x duration condition
fit = [];

fit.ctrpred = {}; fit.cohpred = {};
fit.ctrvar  = {}; fit.cohvar  = {};
fit.ctrr2   = []; fit.cohr2   = [];

fit.init = [0.5, 0.1];
fit.thresh = 0.75;

for isz = 1 : nSz
    for iDur = 1: nDurs
        % fit contrast
        fit.ctrvar{isz}(iDur, :) = fminsearch(@(x) tb_fitWeibull(x, levels,...
            dec.ctrNCorrect{isz}(:, iDur), nRp), fit.init);
        fit.ctrpred{isz}(iDur, :) = tb_Weibull(fit.ctrvar{isz}(iDur, :), levels);
        fit.ctrr2(isz, iDur) = corr(fit.ctrpred{isz}(iDur, :)', dec.ctr{isz}(:, iDur)).^2;
        
        % fit coherence
        fit.cohvar{isz}(iDur, :) = fminsearch(@(x) tb_fitWeibull(x, levels,...
            dec.cohNCorrect{isz}(:, iDur), nRp), fit.init);
        fit.cohpred{isz}(iDur, :) = tb_Weibull(fit.cohvar{isz}(iDur, :), levels);
        fit.cohr2(isz, iDur) = corr(fit.cohpred{isz}(iDur, :)', dec.coh{isz}(:, iDur)).^2;
        
        % find contrast threshold
        diff   = abs(fit.ctrpred{isz}(iDur, :) - fit.thresh);
        minval = find(diff == min(diff));
        fit.ctrthresh(isz, iDur) = levels(minval(1));
        
        % find coherence threshold
        diff   = abs(fit.cohpred{isz}(iDur, :) - fit.thresh);
        minval = find(diff == min(diff));
        fit.cohthresh(isz, iDur) = levels(minval(1));
    end
end

%% find threshold




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
%% plot psychometric functions
figure(3), clf,% colormap gray

for k = 1 : nSz
   subplot(2, nSz, k)
   set(gca, 'ColorOrder', gray(nDurs +1), 'NextPlot', 'replacechildren')
   semilogx(fit.ctrpred{k}(2 : end, :)', 'linewidth', 3), axis tight
   
   subplot(2, nSz, k + nSz),
   set(gca, 'ColorOrder', gray(nDurs +1), 'NextPlot', 'replacechildren')
   semilogx(fit.cohpred{k}(2 : end, :)', 'linewidth', 3), axis tight
   if k == 4,
       subplot(2, nSz, k), title('contrast'), xlabel('contrast'), ylabel('%correct')
       subplot(2, nSz, k + nSz), title('coherence'), xlabel('coherence'), ylabel('%correct')
   end
end

%% plot sensitivity
figure (4), clf

for k = 1 :  nSz
    subplot(1, nSz, k)
    semilogx(durs(2 : end), 1./fit.ctrthresh(k, 2 : end), 'o:'), hold on
    semilogx(durs(2 : end), 1./fit.cohthresh(k, 2 : end), 'o:'), axis tight
    if k == 4, legend('ctr', 'coh'), xlabel('ms'), ylabel('sensitivity'), end
    ylim([0, 100]), title(sz(k))
    set(gca, 'xtick', durs, 'xticklabel', round(16.7.*durs)), 
end