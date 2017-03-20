% tb_compute_wrapper

%% small spatial stimulus

nRepeats = 10;

durs      = [2, 4, 8, 16, 32, 64];
levels    = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.8, 1];
sz1       = [40, 40];
accumWind = 'exponential';
rdRule    = 'maxRsp';

for k = 1 : nRepeats
    [ctr1{k}, coh1{k}] = tb_compute(durs, levels, sz1, accumWind, rdRule);
end

%% big spatial stimulus

sz2 = [100, 100];

for k = 1 : nRepeats
    [ctr2{k}, coh2{k}] = tb_compute(durs, levels, sz2, accumWind, rdRule);
end

%% analyze response

sz1.ctr = zeros(length(levels), length(durs));
sz1.coh = zeros(size(sz1.ctr));

sz2.ctr = sz1.ctr;
sz2.coh = sz1.coh;

for k = 1 : nRepeats
   sz1.ctr  = sz1.ctr + ctr1{k}.mtdecVal;
   sz1.coh  = sz1.coh + coh1{k}.mtdecVal;
end

sz1.ctr = sz1.ctr./nRepeats;
sz1.coh = sz1.coh./nRepeats;

figure (1), clf

subplot(1, 2, 1)
imagesc(sz1.ctr), caxis([0, 1])
subplot(1, 2, 2)
imagesc(sz1.coh), caxis([0, 1])



