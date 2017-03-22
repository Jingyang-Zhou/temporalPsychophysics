function s = tb_fitWeibull(vars, levels, nCorrect, nTotal)
% There are two parameters to be fitted slope and threshold

figureOn = 0;

%% compute Weibull

target = tb_Weibull(vars, levels);
target = target.*.99 + 0.005;

%% compute log likelihood between data and Weibull fit

% size(target)
% size(nCorrect)

s = -tb_logLikelihood(target, nCorrect', nTotal*ones(1, length(nCorrect)), 'log');

%% visualize

if figureOn
    figure (1), clf
    plot(levels, target), hold on
    plot(levels, nCorrect./nTotal), 
    drawnow
end