% Script:  explore_model.m
% Author:  Louis Lin
% Org:     Auckland Bioengineering Institute
% Purpose: Explore the cell model by generating plots of eta and beta
%          perturbations

%% init

clc
clear
close all

param_names = ["$G_{Na}$", "$G_{BK}$", "$G_{Ca}$"];
param_index = 2;
param_length = 2;
param_ranges = [[0,16];[0.5,2.4];[0,8]];

params = ones(3,param_length);
params(1,:) = params(1,:) * 8; %G_Na
params(2,:) = params(2,:) * 1.2; %G_BK
params(3,:) = params(3,:) * 4; %G_Ca
%params(param_index,:) = linspace(param_ranges(param_index,1), param_ranges(param_index,2), param_length);

charac_names = ["Freq (cpm)", "Width (s)", "Upstroke (s)", "Downstroke (s)"];

tspan = [600000, 660000]; % 60s period after 10 min
show_plot = false;

surface = zeros(param_length, param_length, 3);
charac = zeros(4, param_length);

if show_plot
    figure()
end

tic

for j = 1:3
    temp_params = params;
    temp_params(j,:) = linspace(param_ranges(j,1), param_ranges(j,2), param_length);

    for i = 1:param_length
        [VOI,STATES,~,~,freq] = imtiaz_2002d_noTstart_COR_exported(0.00099, 0.039264, temp_params(1,i), temp_params(2,i), temp_params(3,i), tspan, show_plot);
        charac(1,i,j) = freq;
        width = pulsewidth(STATES(:,1),  VOI./1000);
        charac(2,i,j) = mean(width);
        upstroke = risetime(STATES(:,1), VOI./1000);
        charac(3,i,j) = mean(upstroke);
        downstroke = falltime(STATES(:,1), VOI./1000);
        charac(4,i,j) = mean(downstroke);
        %surface(i,j) = freq;
    end
end

fprintf('Average time per iteration: %f s\n', toc/(param_length^3));

fig = figure();
for j = 1:4
    subplot(2,2,j);
    h = plot(1:param_length, charac(j,:,1), 1:param_length, charac(j,:,2), 1:param_length, charac(j,:,3));
    %xlim([params(i,1) params(i,end)]);
    ylabel(charac_names(j));
end

fig_axes = axes(fig, 'visible', 'off');
fig_axes.XLabel.Visible = 'on';
%xlabel(fig_axes, param_names(param_index), 'Interpreter', 'Latex');
%sgtitle('Pulse Characteristics');

%mesh(beta, eta, surface);