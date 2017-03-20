%% Contrast response function
c = linspace(0,1,1000);
crf = c.^2./(.1+c.^2);
figure, plot(c, crf)

%% Temporal response
t = .001:.001:1;
tau = 0.2;
irf = t.* exp(-t/tau);
irf = irf / sum(irf);
figure, plot(t, irf)
%% Outputs
t = .001:.001:10;

% contrasts vary from [0:1];
% durations vary from [0.01 4];
contrasts = linspace(0,1,100);
durations = logspace(log10(0.01), log10(4), 200);
readout = zeros(length(contrasts), length(durations));

for c = 1:length(contrasts)
    for d = 1:length(durations)
        
        stimulus = zeros(size(t));
        stimulus(t<durations(d)) = contrasts(c);
        response = conv(stimulus, irf,'full');
        response = response(1:length(t));
        readout(c,d) = max(response);
    end
end

figure, imagesc(contrasts, durations, readout), axis xy, %colormap gray
xlabel('Contrast')
ylabel('Duration')
hold on,

%% Find minimum contrast value for each duration where response exceeds threshold 
thresh = 0.01;
durationsResampled = logspace(log10(0.01),log10(4), 2000);
contrastsResampled = linspace(0,1,10000);
[Xq, Vq] = meshgrid(...
    durationsResampled, contrastsResampled);

readoutResampled = interp2(durations, contrasts,readout,Xq,Vq);

threshold = zeros(size(durationsResampled));


for d = 1:length(durationsResampled)
    idx = find(readoutResampled(:,d) > thresh, 1);
    if isempty(idx), threshold(d) = inf;
    else threshold(d) = contrastsResampled(idx);
    end
end

figure, clf
plot(durationsResampled*1000, 1./threshold, 'o')
xlabel('Duration (ms)')
ylabel('Threshold (1/contrast)')
set(gca, 'XScale', 'log', 'YScale', 'log', 'XLim', [10 10000],  'YLim', [1 1000])
hold on, plot(2*1000*tau*[1 1], [1 1000], 'k--')