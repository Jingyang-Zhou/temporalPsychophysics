function [v1complexrsp, mtpatternrsp] = tb_mkRsp(stim, pars, dur, ctr)

% INPUTS:
% stim: a cell array of size nctr x ndur

%% pre-defined variables

ndur = length(dur);
nctr = length(ctr);

%% compute model predictions

for k1 = 1 : nctr
    for k2 = 1 : ndur
        [rsp1, ind1] = shModel(stim{k1, k2}, pars, 'V1Complex');
        [rsp2, ind2] = shModel(stim{k1, k2}, pars, 'mtPattern');
        
        v1complexrsp{k1, k2}  = reshape(rsp1, ind1(2, 2), ind1(2, 3), ind1(2, 4), size(rsp1, 2));
        mtpatternrsp{k1, k2} = reshape(rsp2, ind2(2, 2), ind2(2, 3), ind2(2, 4), size(rsp2, 2));
    end
end

end