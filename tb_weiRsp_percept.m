function ro = tb_weiRsp_percept(dir, rsp)

% INPUTS:
% dir: a vector of directions that each neuron is tuned to
% rsp  : of dimension [n neurons, time].

%% Example and useful functions

exampleOn = 0;
normsum   = @(x) x./sum(x);

if exampleOn,
    pars       = shPars;
    dir        = pars.mtPopulationVelocities(:, 1);
    stim       = mkDots([50, 50, 60], pi*1.8, 1);
    [pop, ind] = shModel(stim, pars, 'mtPattern'); 
    rsptmp     = reshape(pop, [ind(2, 2) * ind(2, 3), ind(2, 4), size(pop, 2)]);
    rsp        = squeeze(mean(rsptmp));

    fg = figure; polarplot(dir, ones(1, length(dir)), 'ko'), hold on
end

%% reshape response

% response is compressed over space (uniform in space)
% rsrsp = mean(reshape(rsp, [size(rsp, 1)*size(rsp, 2), size(rsp, 3), size(rsp, 4)]));
% rsrsp = squeeze(rsrsp);
%% compute weighted sum

xcmp = cos(dir);
ycmp = sin(dir);
ro   = [];


% re-compose the direction and amplitude
for t = 1 : size(rsp, 2)
   rsp_n(t, :) = normsum(rsp(:, t)); % normalize the response amplitudes at each time point to the sum 

   x(t, :) = rsp_n(t, :).*xcmp'; % x-component amplitude
   y(t, :) = rsp_n(t, :).*ycmp'; % y-component amplitude
   
   sx = sum(x(t, :)); % weighted sum along x-direction
   sy = sum(y(t, :)); % weighted sum along y-direction
   
   % compute amplitude
   %ro.amp(t) = sqrt(sx^2 + sy^2);
   ro.amp(t)  = sum(rsp(:, t));
   
   % compute the combined direction -- needs to be re-written
   ratio = abs(sy/sx);
   
   if sx >= 0 & sy >= 0, ro.ang(t) = atan(ratio);
   elseif sx < 0 & sy >= 0, ro.ang(t) = pi - atan(ratio);
   elseif sx < 0 & sy < 0, ro.ang(t) = pi + atan(ratio);
   else ro.ang(t) = 2*pi - atan(ratio);
   end 
end

if exampleOn
   fg1 = figure; 
   tmp = sum(rsp_n);
   subplot(1, 2, 1), polarplot(dir, tmp, 'o:'); title('channel rsp. amp.')
   subplot(1, 2, 2), polarplot(ro.ang, ro.amp, 'ko', 'markerfacecolor', 'k', 'markeredgecolor', 'w', 'markersize', 10); 
   title('percept at each time point')
end

%% comments

% The distribution of the percept depends on the distribution of MT neurons
% speed tunings. If the distribution is uniform (n. neurons per speed),
% then the percept should be equally reliable for each speed. Otherwise
% some speed is easier for the task than others.


end