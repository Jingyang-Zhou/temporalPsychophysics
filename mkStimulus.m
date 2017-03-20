
% make stimulus, variables: contrast, duration, coherence
function mdIm = mkStimulus(duration, contrast, coherence)

% contrast  = 1;
% coherence = 10;
% duration  = 2.5; % second
%% paths

expStimPth = fullfile(tBevRootPath, 'stimulus', 'motionDiscriminationStaircase');
addpath(expStimPth)

%% pre-defined parameters

cal = 'Rm957C_CRT'; 
dataDir          = mdInitDataDir;
display          = attInitDisplay(cal); 

scale_factor = 3;
innerRadius  = 1.5/2; % in degrees

radius_in_degrees = 5 / scale_factor;
radius_in_pixels  = round(angle2pix(display, radius_in_degrees));

[x, y] = meshgrid(linspace(-radius_in_degrees, radius_in_degrees, radius_in_pixels*2));

%% pre-define dot properties

dots     = [];
backColorIndex = 128;


display          = mdInitFixParams(display);

stimParams.duration    = duration;
stimParams.contrast    = contrast;
stimParams.coherence   = coherence;
stimParams.dot_number  = 200;
stimParams.dotCohOrder = randi(stimParams.dot_number, 1, stimParams.dot_number);
stimParams.inward_or_outward = 1;


dots.color   = round((1 + [1 -1]*(stimParams.contrast)) * display.backColorIndex);
dots.num     = stimParams.dot_number;               % always 200 dots
dots.num_coh = dots.num * stimParams.coherence/100;

dots.r             = rand(dots.num,1)*radius_in_degrees; % radius
dots.th            = rand(dots.num,1)*pi*2;              % angle

dots.sz            = 14 / 60 / 2 / scale_factor;           % in deg (14 arc min diameter, 7 arc min radius)
dots.deg_per_s     = 4.7 / scale_factor;
dots.deg_per_frame = dots.deg_per_s / display.frameRate; % deg / second

if stimParams.inward_or_outward == 1, dots.dir = -1;
else dots.dir = 1; end

% change frame rate here , CHECK LATER --------------------------------------------
display.frameRate = 75;
num_frames = round(stimParams.duration * display.frameRate);
mdIm       = display.backColorIndex + ...
    zeros(radius_in_pixels*2, radius_in_pixels*2, num_frames, 'uint8');
blank_im = zeros(size(mdIm,1), size(mdIm,2), 'uint8') + display.backColorIndex; % need to rescale it to 0 - 1

%% make moving dots
for f = 1 : num_frames
    %fprintf('.'); drawnow();
    this_im = blank_im;
    [dots.x, dots.y] = pol2cart(dots.th, dots.r);
    
    for ii = 1:dots.num
        idx = (x-dots.x(ii)).^2+(y-dots.y(ii)).^2 < dots.sz^2;
        if ii < dots.num/2, this_im(idx) = dots.color(1);
        else this_im(idx) = dots.color(2); end
    end
    mdIm(:,:,f) = this_im;
    
    % move
    permuted_order = randperm(dots.num);
    coh_idx        = permuted_order(1:dots.num_coh);
    rnd_idx        = permuted_order(dots.num_coh + 1:dots.num);    
    
    dots.r(coh_idx) = dots.r(coh_idx) + dots.dir * dots.deg_per_frame;
    
    %   random dots disappear and reappear in random position (random angles and radius)
    
    dots.r(rnd_idx)  = rand(length(rnd_idx),1)*radius_in_degrees;
    dots.th(rnd_idx) = rand(length(rnd_idx),1)*2*pi;
    
    % check on whether dots moved past center or moved out of frame
    
    past_centerhole          = dots.r < innerRadius/scale_factor;          % in degrees
    dots.r(past_centerhole)  = radius_in_degrees - dots.r(past_centerhole);
    dots.th(past_centerhole) = rand(sum(past_centerhole),1)*2*pi;
    %
    past_edge                = dots.r > radius_in_degrees;
    dots.r(past_edge)        = dots.r(past_edge) - radius_in_degrees + innerRadius/scale_factor;
    dots.th(past_edge)       = rand(sum(past_edge),1)*2*pi;
end

%% save
mdIm = imresize(mdIm, scale_factor, 'nearest');
% % scale stimulus between 0 and 1
%mdIm = double(round(mdIm./max(mdIm(:))));
mdIm = double(mdIm)./255;
% 
% saveLoc = fullfile(tBevRootPath, 'output');
% fileName = sprintf('mdDur%dCtr%dCoh%d', duration*1000, contrast*100, coherence);
% 
% save(fullfile(saveLoc, fileName), 'mdIm')
end
