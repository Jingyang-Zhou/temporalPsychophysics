% tmp - visaulize neuronal output from MT model

% s is the stimulus

res1 = shGetSubPop(pop, ind); % directional response
[m,n] = size(pop); % n=28 for v1 stages; n = 19 for MT stages; 
res2 = reshape(pop, [size(res1) n]); % population response

figure (1), clf, colormap gray
for k = 1 : n
   subplot(1, 2, 1)
   imagesc(res1(:, :, k)), axis square
   subplot(1, 2, 2)
   imagesc(res2(:, :, 1, k)), axis square
   pause (0.5)
end



