function ro = tb_read_percept(rsp, whichrule, pars, v1ormt)
% There are four rules so far:
% (1) weiRsp : this ignore speed at this moment
% (2) maxRsp
% (3) oppRsp
%
% Each "perception rule", the second file computes the decision rule
%
% SO FAR THIS ONLY APPLIED TO MT.

% the inputting response herer is the windowed response, and works only for
% moving stimulus?

% rsp: time series x n neurons (NEED TO TAKE A MORE GENERAL RESPONSE FUNCTION, NOT COMBINING OVER SPACE)
%% prep

mtdir = pars.mtPopulationVelocities(:, 1); % could be changed if we want more neurons
v1dir = pars.v1PopulationDirections(:, 1);

switch v1ormt
    case 'v1'
        dir = pars.v1PopulationDirections(:, 1);
    case 'mt'
        dir = pars.mtPopulationVelocities(:, 1); % could be changed if we want more neurons
end

sz1   = size(rsp, 1);
sz2   = size(rsp, 2);

normsum = @(x) x./sum(x);

%% forming percept

switch whichrule
    case 'weiRsp' 
        for k1 = 1 : sz1
            for k2 = 1 : sz2
                ro{k1, k2} = tb_weiRsp_percept(dir, rsp{k1, k2});
            end
        end
       % "ro" has two componented, ro.amp and ro.ang. ro.ang is the summed
       % angle, and ro.amp is the summed amplitude.
       
    case 'maxRsp'
        for k1 = 1 : sz1
            for k2 = 1 : sz2
                ro{k1, k2} = tb_maxRsp_percept(dir, rsp{k1, k2});
            end
        end
    case 'oppRsp'
        
end
end