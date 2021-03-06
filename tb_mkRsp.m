function [v1complexrsp, mtpatternrsp] = tb_mkRsp(stim, pars, dur, ctr, v1thresh)

% so far it is assuming that we use the default neurons (28 types of v1 population, and 19 types of MT population, will change this later)


% INPUTS:
% stim: a cell array of size nctr x ndur

%% pre-defined variables

ndur = length(dur);
nctr = length(ctr);

%% compute model predictions

for k1 = 1 : nctr
    for k2 = 1 : ndur
        % compute V1 complex cell response
        [rsp1, ind1] = shModel(stim{k1, k2}, pars, 'V1Complex');
        rsp1(rsp1 < v1thresh) = 0;
        
        % compute MT response
        
        [pop, ind] = shModelMtLinear(rsp1, ind1, pars);
        [pop, ind] = shModelMtPreThresholdBlur(pop, ind, pars);
        [pop, ind] = shModelHalfWaveRectification(pop, ind, pars);
        [pop, ind] = shModelMtPostThresholdBlur(pop, ind, pars);
        [rsp2, ind2, nume, deno] = shModelMtNormalization(pop, ind, pars);
        
        %[rsp2, ind2] = shModel(stim{k1, k2}, pars, 'mtPattern');
        
        v1complexrsp{k1, k2} = reshape(rsp1, ind1(2, 2), ind1(2, 3), ind1(2, 4), size(rsp1, 2));
        mtpatternrsp{k1, k2} = reshape(rsp2, ind2(2, 2), ind2(2, 3), ind2(2, 4), size(rsp2, 2));
    end
end

%% visualize v1 and mt response

% v1rsp = reshape(rsp1, ind1(2, 2), ind1(2, 3), ind1(2, 4), size(rsp1, 2));
% mtrsp = reshape(rsp2, ind2(2, 2), ind2(2, 3), ind2(2, 4), size(rsp2, 2));
% 
% mv1rsp = squeeze(mean(mean(v1rsp),2));
% mmtrsp = squeeze(mean(mean(mtrsp), 2));
% 
% figure (1), clf 
% subplot(2, 2, 1)
% imagesc(squeeze(v1rsp(:, :, 6, 1))), colorbar
% subplot(2, 2, 2)
% imagesc(squeeze(mtrsp(:, :, 6, 1))), colorbar
% subplot(2, 2, 3)
% plot(mv1rsp), box off, axis tight
% subplot(2, 2, 4)
% plot(mmtrsp), box off, axis tight

end