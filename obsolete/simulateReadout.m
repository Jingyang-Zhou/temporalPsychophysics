% simulate burr and santoro generate output


%% load stimulus

stimLoc = fullfile(tBevRootPath, 'output');
saveLoc = fullfile(tBevRootPath, 'output1');
fname   = 'CtrCohStim.mat';
a       = load(fullfile(stimLoc, fname));

ctrStim = a.ctrStim;
cohStim = a.cohStim;


nVary = size(ctrStim, 1);

%% plot stimulus

figure (1), clf

for k = 1 : nVary
   subplot_tight(2, 4, k, 0.05)
   imshow(squeeze(cohStim{1, k}(:, :, 3)))
end


%% generate contrast-varying output and coherence-varying output

pars = shPars;

for k = 1 : nVary
    for k1 = 1 : nVary
        s1 = ctrStim{k, k1};
        
        % generate readout
        [pop1, ind1] = shModel(s1, pars, 'v1complex');
        % reshape output
        rspCtr = reshape(pop1, ind1(2, 2), ind1(2, 3), ind1(2, 4), size(pop1, 2));
        
        s2 = cohStim{k, k1};
        % generate readout
        [pop2, ind2] = shModel(s2, pars, 'v1complex');
        % reshape output
        rspCoh = reshape(pop2, ind2(2, 2), ind2(2, 3), ind2(2, 4), size(pop2, 2));
        
        sName = sprintf('rspDur%dCtr%d', a.param.duration(k)*1000, a.param.contrast(k1)*100);
        save(fullfile(saveLoc, sName), 'rspCtr')
        
        sName1 = sprintf('rspDur%dCoh%d', a.param.duration(k)*1000, a.param.coherence(k1));
        save(fullfile(saveLoc, sName1), 'rspCoh')
    end

end

%% save output

%save(fullfile(stimLoc, 'modelOutput', 'rspCtr', 'rspCoh'))


