function noisyOutput = tb_addnoise(rsp, noiseAmp)

% rsp here is a cell with all responses

%% pre-defined variables

noisyOutput = [];

sz1 = size(rsp, 1);
sz2 = size(rsp, 2);


for k1 = 1 : sz1
    for k2 = 1 : sz2
        noisesz = size(rsp{k1, k2});
        noise  = randn(noisesz).*noiseAmp;
        noisyOutput{k1, k2} = rsp{k1, k2} + noise;
    end
end


end