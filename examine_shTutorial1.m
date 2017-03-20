% try to understand shTutorial1.m

%% load parameters

pars = shPars;


%% V1 motion directions

v1dir = pars.v1PopulationDirections(:, 1);
v1spd = pars.v1PopulationDirections(:, 2);
nv1dir = length(v1dir);

fg = figure (1); clf, colors = copper(length(v1dir));

for k = 1 : nv1dir
    p = polarplot([0, v1dir(k)], [0, v1spd(k)], 'o-', 'color', colors(k, :), 'markersize', 15); hold on
    p.MarkerFaceColor = colors(k, :);
end

% plot preferred direction, spatial frequency and temporal frequency

figure (2), clf

plot3(v1dir, v1spd, ones(1, nv1dir), 'ko')