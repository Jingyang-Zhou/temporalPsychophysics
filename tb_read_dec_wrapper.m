function ro = tb_read_dec_wrapper(ro, whichrule, pars)



%% pre-defined variables

sz1 = size(ro, 1);
sz2 = size(ro, 2);

%% compute decision

for k1 = 1 : sz1
    for k2 = 1 : sz2
        ro{k1, k2} = tb_read_decision(ro{k1, k2}, whichrule, pars);
    end
end

end