function ro = tb_maxRsp_percept(dir, rsp)
% 
% INPUTS:
% dir : a vector of directions that each neuron is tuned to
% rsp : of dimension [n neurons, time]

%% example and useful functions

exampleOn = 0;
normsum   = @(x) x./sum(x);

if exampleOn,
    pars       = shPars;
    dir        = pars.mtPopulationVelocities(:, 1);
    stim       = mkDots([50, 50, 60], pi*1.8, 1);
    [pop, ind] = shModel(stim, pars, 'mtPattern'); 
    rsptmp     = reshape(pop, [ind(2, 2) * ind(2, 3), ind(2, 4), size(pop, 2)]);
    rsp        = squeeze(mean(rsptmp));

    fg = figure; polarplot(dir, ones(1, length(dir)), 'ko'), hold on
end

%% compute maximum response at each time point

for t = 1 : size(rsp, 2)
    idx = find(rsp(:, t) == max(rsp(:, t)));
    ro.dir(t) =  dir(idx(1));
end

end