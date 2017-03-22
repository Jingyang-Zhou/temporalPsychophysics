function [ind_ro, idx] = tb_read_decision(ind_ro, whichrule, pars)
%
% There are four rules so far:
% (1) weiRsp : this ignore speed at this moment
% (2) maxRsp
% (3) oppRsp

%% prep


%% decision

switch whichrule
        % ro have two fields, ro.amp (amplitude of the weighted summed
        % rsp), and ro.ang (angle of the combined response)
        
        % going to make a decision based on whether combined direction is
        % to the left or to the right, amplitude could be a measure of
        % confidence
        
        % drawback is if the task is to tell inward from outward moving,
        % needs to take neuron's location into account. e.g. a neuron at
        % the left visual field tuned to the right represents inward
        % tuning.
    case 'weiRsp'
        idx = [];
        L = length(ind_ro.ang);
        for k = 1 : L
            if (ind_ro.ang(k) > pi/2) & (ind_ro.ang(k) <= 1.5*pi), idx(k) = 1;
            else idx(k) = 0;
            end
        end
        % amplitude could be used to compute confidence
        
    case 'maxRsp'
        L = length(ind_ro.dir); 
        for k = 1 : length(ind_ro.dir)
            if (ind_ro.dir(k) > pi/2) & (ind_ro.dir(k) <= 1.5*pi), idx(k) = 1;
            else idx(k) = 0;
            end
        end
        
    case 'oppRsp' 
end

% summarize index


if idx(end) == 1,
    ind_ro.dec = 'l';
    ind_ro.decVal = 1;
else
    ind_ro.dec = 'r';
    ind_ro.decVal = 0;
end


end