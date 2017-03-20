function [accum_rsp, window] = tb_accumWind(whichType, rsp, dur, ctr)

% There are four types of windows I want to test: 
% 1. infinite window
% 2. finite window - on-off (integrates finite pass)
% 3. low-pass window - exponential decay

% Example:
% whichType = 'exponential';
 figureOn = 0;

%% pre-defined variables

t      = 0.001 : 0.001 : 1;
window = zeros(1, length(t));
frmRt  = 60;

ndur   = length(dur);
nctr   = length(ctr);

normSum = @(x) x./sum(x);

%% make window

switch whichType
    case 'infinite', window(:) = 1;
    case 'rectangular'
        winlth  = 100; window(1 : winlth) = 1; % unit : ms  
    case 'exponential'
        tau = 0.15; window = exp(-t./tau); 
    case 'point'
        window(1) = 1;
end

window = window(1 : frmRt : end);
window = normSum(window);
smp    = t(1 : frmRt : end);

%% reshape response



%% convolve with response
accum_rsp = {};

for k1 = 1 : nctr
    for k2 = 1 : ndur
        r = rsp{k1, k2};
        rsr = reshape(r, [size(r, 1) * size(r, 2), size(r, 3), size(r, 4)]);
        rsr = squeeze(mean(rsr));
        
        for k3 = 1 : size(rsr, 2)
            accum_rsp{k1, k2}(k3, :) = convCut(window, rsr(:, k3), size(rsr, 1));
        end
    end
end

%% plot window

if figureOn
   figure, plot(smp, window) 
end

end