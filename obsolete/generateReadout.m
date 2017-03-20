% generate readout

stimLoc = fullfile(tBevRootPath, 'output1');
stimLoc1 = fullfile(tBevRootPath, 'output');

% load stimulus parameters
fname   = 'CtrCohStim.mat';
a       = load(fullfile(stimLoc1, fname));

ctr = a.param.contrast.*100;
coh = a.param.coherence;
dur = a.param.duration.*1000;

%% load data

nDur = length(dur);

for k = 1 : nDur
     for k1 = 1 : length(coh)
        fname1 = sprintf('rspDur%dCtr%d.mat', dur(k), ctr(k1));
      %  fname2 = sprintf('rspDur%dCoh%d.mat', dur(k), coh(k1));
        a1 = load(fullfile(stimLoc, fname1));
       % a2 = load(fullfile(stimLoc, fname2));

        ctrRsp{k, k1} = a1.rspCtr;
        %cohRsp{k, k1} = a2.rspCoh;
        k1
    end
end

% response dimension:
% [x, y, time, tuning]
%% example neuronal response

maxtime = 43; %%%%%%%%%%%%%%%%%%%%%% change this

figure (3), clf, colormap gray

for k = 1 : 28
   subplot_tight(5, 6, k, 0.02)
   imagesc(squeeze(mean(ctrRsp{2, 2}(:, :, 1, k), 3)));
   caxis([0.0, 0.02]), axis off
end


x = 100; y = 100; rsctrRsp = reshape(ctrRsp', [1, nDur * length(coh)]);

figure (4), clf

for k = 1 : nDur * length(coh)
   subplot_tight(nDur, 7, k, 0.03)
   if size(rsctrRsp{k}, 3) == 1
       plot(squeeze(rsctrRsp{k}(x, y, :, :)), 'k.')
   else
   plots(rsctrRsp{k}(x, y, :, :)), 
   end
   axis tight, box off, ylim([0, 0.9]), xlim([0, maxtime])
   if ~ismember(k, [1, 8, 15, 22, 29, 36, 43]), set(gca, 'yticklabel', ''); axis off, end
end



%% maximum readout

% compute the maximum response in each matrix
for k = 1 : nDur
   for k1 = 1 : length(coh)
      maxReadout(k, k1) = max(ctrRsp{k, k1}(:)); 
   end
   k
end

%% thresholding

thresh = 0.2;
for k = 1 : nDur
    tmp      = abs(maxReadout(k, :) - thresh);
    idx(k)   = find(tmp == min(tmp))
    level(k) = tmp(idx(k));
end

%% visualize maximum readout

figure (1), clf, colormap gray
%subplot(1, 2, 1)
imagesc(maxReadout), hold on
for k = 1 : nDur
   plot(idx(k), k, 'r*') 
end
xlabel('contrast'), ylabel('duration'), axis square

%subplot(1, 2, 2)
%plot(1./level), title('sensitivity')

%% average of the highest response readout

for k = 1 : nDur
   for k1 = 1 : length(coh)
       % find the neuron that has the highest response throughout
       tmp = ctrRsp{k, k1};
       sz  = size(tmp);
       rsrsp = reshape(tmp, [sz(1)*sz(2)*sz(3), sz(4)]);
       mrsrsp = mean(rsrsp);
       aveMax(k, k1) = max(mrsrsp);
       aveAve(k, k1) = mean(mrsrsp);
   end
end

%% visualize aveMax and aveAve output
figure (2), clf, colormap gray
subplot(1, 2, 1), imagesc(aveMax), axis square
subplot(1, 2, 2), imagesc(aveAve), axis square

%% sum readout
for k = 1 : nDur
   for k1 = 1 : length(coh)
      sumRsp(k, k1) = sum(ctrRsp{k, k1}(:)); 
   end
end

%% visualize

figure (7), clf, colormap gray

imagesc(sumRsp), axis square

%% visualize response

pop = ctr{4, 2}; % size 288, 288, 4, 19

% plot selected neuron time series
nLoc = 120;
figure (1), clf,
plots(pop(nLoc, nLoc, :, :))

