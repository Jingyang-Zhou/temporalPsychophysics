% autocorrelation simulation

%% useful functions

normMax = @(x) x./max(x);

%%

stimLth = 1;
dt      = 0.001;
t       = 0.001 : dt : stimLth;

stim = zeros(1, length(t)); stim(1 : 100) = 1;
stim = 
tau1 = 0.1;
trf  = normMax(gammaPDF(t, tau1, 2));
rsp  = normMax(convCut(trf, stim, length(t)));

figure (1), clf
plot(trf), hold on
plot(rsp), legend('trf', 'rsp')

%% compute autocorrelation

auto = convCut(stim, fliplr(trf), length(t));




