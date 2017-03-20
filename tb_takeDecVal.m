function decVal = tb_takeDecVal(dec, durs, levels)

decVal = [];

for k1 = 1 : length(levels)
    for k2 = 1 : length(durs)
        decVal(k1, k2) = dec{k1, k2}.decVal; 
    end
end

end