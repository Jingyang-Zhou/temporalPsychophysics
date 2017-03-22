function [ctr, coh, ctrstim, cohstim] = tb_compute(durs, levels, sz, whichAccumWind, whichRdRule, noiselevel)
% 
% INPUTS:
%       durs  : a vector of stimulus durations
%       levels: a vector of stimulus levels, between 0 and 1, could either be
%               contrast or coherence levels
%       sz    : stimulus size in the spatial dimension, for example, [40, 40]
%       whichAccumWind: options "infinite", "rectangular", "exponential",
%                "point"
%       whichRdRule: options are "weiRsp" and "maxRsp" at the moment
%       noiseLevel: the scale of the standard deviation of gaussian noise
%               added to the final stage of the neuronal response.
%
% OUTPUS:
%% EXAMPLE
if ~exist('durs', 'var'),   durs   = [3, 6, 10, 70]; end
if ~exist('levels', 'var'), levels = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]; end
if ~exist('sz', 'var'),     sz     = [50, 50]; end
if ~exist('whichAccumWind', 'var'), whichAccumWind = 'exponential'; end
if ~exist('whichRdRule', 'var'), whichRdRule = 'weiRsp'; end
if ~exist('noiselevel', 'var'), noiselevel = 0; end

%% default parameters

v1thresh = 0.01;
figureOn = 0;
hpcOn    = 1;

%% derived parameters

nlevels = length(levels);
ndurs   = length(durs);

%% initialize the computation

ctr  = [];
coh  = [];

% load model parameters
pars = shPars();

areas = {'v1', 'mt'};
    
%% make stimulus

[ctrstim, cohstim]= tb_mkStim(durs, levels, sz);

% visualize stimulus:
% flipBook(coh.stim{3, 4})

%% compute V1 and MT responses

[ctr.v1rsp, ctr.mtrsp] = tb_mkRsp(ctrstim, pars, durs, levels, v1thresh);
[coh.v1rsp, coh.mtrsp] = tb_mkRsp(cohstim, pars, durs, levels, v1thresh);

if hpcOn, clear ctrstim cohstim;  end
%% accumulation

condRsp   = {'v1rsp', 'mtrsp'};
condAccum = {'v1acc', 'mtacc'};

for k = 1 : length(condAccum)
   ctr.(condAccum{k}) = tb_accumWind(whichAccumWind, ctr.(condRsp{k}), durs, levels);
   coh.(condAccum{k}) = tb_accumWind(whichAccumWind, coh.(condRsp{k}), durs, levels);
end

if hpcOn, ctr.v1rsp = []; coh.v1rsp = []; ctr.mtrsp = []; coh.mtrsp = []; end
%% compute percept

condPrct = {'v1prct', 'mtprct'};

for k = 1 : length(condPrct)
    ctr.(condPrct{k}) =  tb_read_percept(ctr.(condAccum{k}),  whichRdRule, pars, areas{k});
    coh.(condPrct{k}) =  tb_read_percept(coh.(condAccum{k}),  whichRdRule, pars, areas{k});
end

if hpcOn, ctr.v1acc = []; coh.v1acc = []; ctr.mtacc = []; coh.mtacc = []; end
%% decision

condDec = {'v1dec', 'mtdec'};

for k = 1 : length(condDec)
   ctr.(condDec{k}) = tb_read_dec_wrapper(ctr.(condPrct{k}), whichRdRule, pars);
   coh.(condDec{k}) = tb_read_dec_wrapper(coh.(condPrct{k}), whichRdRule, pars);
end

if hpcOn, ctr.v1prct = []; coh.v1prct = []; ctr.mtprct = []; coh.mtprct = []; end
%% organize decision values

condDecVal = {'v1decVal', 'mtdecVal'};

for k = 1 : length(condDecVal)
   ctr.(condDecVal{k}) = tb_takeDecVal(ctr.(condDec{k}), durs, levels);
   coh.(condDecVal{k}) = tb_takeDecVal(coh.(condDec{k}), durs, levels);
end

if hpcOn, ctr.v1dec = []; coh.v1dec = []; ctr.mtdec = []; coh.mtdec = []; end
%% visualize accumulation

toplot = ctr.mtacc;

if figureOn
    figure (1), clf
    for k1= 1: nlevels
        for k2 = 1 : ndurs
            subplot_tight(nlevels, ndurs, (k1 - 1) * ndurs + k2, 0.05)
            plot(toplot{k1, k2}')
            xlim([0, max(durs)]), box off, %ylim([0, 1]), 
        end
    end
end

%% visualize percept

if figureOn
    toplot = {ctr.mtprct, coh.mtprct};
    for k = 1:2
        fg = figure;
        for k1 = 1 : nlevels
            for k2 = 1 : ndurs
                subplot_tight(nlevels, ndurs, (k1 - 1) * ndurs+k2, 0.05)
                switch whichRdRule
                    case 'weiRsp'
                        polarplot(toplot{k}{k1, k2}.ang(end), toplot{k}{k1, k2}.amp(end), 'k.', 'markersize', 20)
                    case 'maxRsp'
                        distance = ones(1, length(toplot{k}{k1, k2}.dir));
                        polarplot(toplot{k}{k1, k2}.dir, distance, 'k.', 'markersize', 20)
                    case 'oppRsp'                
                end
                if k1 == 1, title(durs(k2)); end
                if k2 == 1, title(levels(k1)); end
                if k1 == 1 && k2 == 1, title(sprintf('%d, %3.2f', durs(k2), levels(k1))); end
            end
        end
    end
end

%% visualize decision

if figureOn
   fg = figure;
   toplot = coh.mtdec; % coh.mtdec
   for k1 = 1 : nlevels
       for k2 = 1 : ndurs
           dec(k1, k2) = toplot{k1, k2}.decVal;
       end
   end
   imagesc(dec)
end
