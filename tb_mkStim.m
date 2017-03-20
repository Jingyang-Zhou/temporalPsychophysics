function [s_ctr, s_coh] = tb_mkStim(dur, ctr, sz, blank)


%% pre-defined variables

if ~exist('blank', 'var'), blank = ones([sz, 4]).*0.5; end

%% prep to make stimulus

s_ctr  = {}; s_coh  = {};

% stimulus inputs:
dotDir = pi; dotSpd = 1; ndur = length(dur); nlev = length(ctr);

%% make stimulus

for k = 1 : ndur
    stimSz = [sz, dur(k)];
    for k1 = 1 : nlev
        tmp = 0.5 + (mkDots(stimSz, dotDir, dotSpd, 0.1, 1) - 0.5).*ctr(k1);
        % make contrast stimulus
        s_ctr{k1, k} = cat(3, blank, blank, tmp);
        % make coherence stimulus
        s_coh{k1, k} = cat(3, blank, blank, ...
            mkDots(stimSz, dotDir, dotSpd, 0.1, ctr(k1)));
    end
end

end