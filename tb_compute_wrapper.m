% tb_compute_wrapper
function [] = tb_compute_wrapper(sz, accumWind, rdRule)

%%

nRepeats = 50;

durs      = [2, 4, 8, 16, 32, 64];
levels    =  logspace(log10(.01), log10(1), 20); 

% accumWind = 'exponential';
% rdRule    = 'maxRsp';

%% compute

for isz = 1 : length(sz)
    parfor k = 1 : nRepeats
        [ctr, coh] = tb_compute(durs, levels, [sz(isz), sz(isz)], accumWind, rdRule);
        
        a{k} = ctr.mtdecVal;
        b{k} = coh.mtdecVal;
        c{k} = ctr.v1decVal;
        d{k} = coh.v1decVal;
        
    end
    dVal{isz}.mtctr = a;
    dVal{isz}.mtcoh = b; 
    dVal{isz}.v1ctr = c;
    dVal{isz}.v1coh = d;
end

%%  get output

saveLoc = fullfile(tb_rootPath, 'output');
saveNm  = sprintf('dVal%d%s', sz, accumWind);

save(fullfile(saveLoc, saveNm), 'dVal')

end

