% Script:  pulse_characs.m
% Author:  Louis Lin
% Org:     Auckland Bioengineering Institute
% Purpose: Calculates and plots the average width, average
%          upstroke, and average downstroke of simulated slow wave signals
%          from the 1D cell model

%% init

clc
clear
close all
addpath('../MEA_simulation') % for simplified_cell_model.m

% define parameters
eta = 0.000991; % ms^-1
beta = 0.039271; % ms^-1
G_Na = 8; % mS
G_BK = 1.2; % mS
G_Ca = 4; % mS
tspan = [600000 660000]; % milliseconds
showplot = true; % plot Vm vs. t

% indices to plot wave width
width_start = 3000;
width_end = 5000;

% indices to plot upstroke
upstroke_start = 3400;
upstroke_end = 3800;
upstroke_percentage = [25 75]; % thresholds

% indices to plot downstroke
downstroke_start = 1;
downstroke_end = 5000;
downstroke_percentage = [25 75]; % thresholds

%% main

% call cell model
[VOI,STATES,~,~,peaks] = simplified_cell_model(eta, beta, G_Na, G_BK, G_Ca, tspan, showplot);

figure
plot(VOI./1000, STATES(:,1));
title('Baseline Cell Model Simulated Slow Wave');
xlabel('Time (s)');
ylabel('$V_{m}$ (mV)', 'Interpreter', 'Latex');

%% plotting

% plot wave width
figure
pulsewidth(STATES(width_start:width_end,1), VOI(width_start:width_end)./1000);
width = pulsewidth(STATES(:,1),  VOI./1000);
title('Slow Wave Width at Half Max-Amplitude');
xlabel('Time (s)');
ylabel('Pacemaker Potential (mV)');
fprintf('Mean width: %fs \n', mean(width));

% plot upstroke
figure
risetime(STATES(upstroke_start:upstroke_end,1), VOI(upstroke_start:upstroke_end)./1000, 'PercentReferenceLevels', upstroke_percentage);
upstroke = risetime(STATES(:,1), VOI./1000);
title(['Pacemaker Potential Half Upstroke (', num2str(upstroke_percentage(1)), '%-', num2str(upstroke_percentage(2)), '%)']);
xlabel('Time (s)');
ylabel('Pacemaker Potential (mV)');
fprintf('Mean upstroke: %fs \n', mean(upstroke));

% plot downstroke
figure
falltime(STATES(downstroke_start:downstroke_end,1), VOI(downstroke_start:downstroke_end)./1000, 'PercentReferenceLevels', downstroke_percentage);
downstroke = falltime(STATES(:,1), VOI./1000);
title(['Pacemaker Potential Half Downstroke (', num2str(downstroke_percentage(1)), '%-', num2str(downstroke_percentage(2)), '%)']);
xlabel('Time (s)');
ylabel('Pacemaker Potential (mV)');
fprintf('Mean downstroke: %fs \n', mean(downstroke));