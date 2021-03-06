% tb_compute_wrapper_wrapper

addpath(genpath(fullfile(tb_rootPath)))
shCompileMex

%% exponential integration window

accumWind = 'exponential';
rdRule    = 'maxRsp';

sz  = 40 : 10 : 100;
nsz = length(sz);

for k = 1 : nsz
     tb_compute_wrapper(sz(k), accumWind, rdRule);
end


%% infinite integration window

accumWind = 'infinite';
rdRule    = 'maxRsp';

sz  = 40 : 10 : 100;
nsz = length(sz);

for k = 1 : nsz
     tb_compute_wrapper(sz(k), accumWind, rdRule);
end

%% point integration window

accumWind = 'point';
rdRule    = 'maxRsp';

sz  = 40 : 10 : 100;
nsz = length(sz);

for k = 1 : nsz
     tb_compute_wrapper(sz(k), accumWind, rdRule);
end