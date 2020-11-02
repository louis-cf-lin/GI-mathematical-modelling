% Script:  animate_raw_signal.m
% Author:  Louis Lin
% Org:     Auckland Bioengineering Institute
% Purpose: Reads in raw MEA signal data (.mat file) and animate as heat map

%% init

clear
clc
close all

addpath('../raw_data'); % folder containing raw data in .mat file
name = '0_0315_ach-at_0'; % file name
load(join(name,'.mat')); % load in data file

nx = size(config, 1); % array size in x-axis
ny = size(config, 2); % array size in y-axis
step = 10; % interval between heat map plots
nt = size(filt_data,2); % total time steps
Vm = NaN(nx, ny, nt); % for all signals arranged

%% arrange data

t = 1;
for i = 1:nx
    for j = 1:ny
        % check for corner node
        if ~(i == 1 && j == 1) && ~(i == 1 && j == 8) && ~(i == 8 && j == 1) && ~(i == 8 && j == 8)
            Vm(i,j,:) = filt_data(t,:);
            t = t + 1;
        end
    end
end

%% plot electrode trace signals

for i = 1:nx
    for j = 1:ny
        % check for corner node
        if ~(i == 1 && j == 1) && ~(i == 1 && j == 8) && ~(i == 8 && j == 1) && ~(i == 8 && j == 8)
            [pks, locs] = findpeaks(squeeze(Vm(i,j,:)));
            peaks = numel(pks);
            freq = (peaks - 1)/((locs(end) - locs(1))/100)*60;
        end
    end
end

%% animate heat map

% colour bar scale
cold = min(min(filt_data));
hot = max(max(filt_data));

bitmap = zeros(nx-1, ny-1);
% heat map options
figh = figure('MenuBar', 'none', 'ToolBar', 'none', 'Color', 'white');
axes('Parent', figh, 'XColor', 'white', 'YColor', 'white', 'Color', 'white');

for t = 1:step:size(filt_data,2)
    % clear current figure
    clf

    % element is average of four corner nodes
    for i = 1:(nx-1)
        for j = 1:(ny-1)
            bitmap(i,j) = (Vm(i,j,t) + Vm(i,j+1,t) + Vm(i+1,j,t) + Vm(i+1,j+1,t))/4;
        end
    end

    % plot heat map
    h = heatmap(bitmap, ... 
        'Colormap', jet, ... 
        'ColorLimits', [-200 200], ...
        'MissingDataLabel', '', ... 
        'MissingDataColor', 'white', ...
        'GridVisible', 'off', ...
        'ColorbarVisible', 'off', ...
        'Position', [0.1 0.1 0.8 0.8]);
    title(['t = ', num2str(filt_t(t)/1000), 's']);

    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));

    % capture frame
    movieVector(round(t/step)+1) = getframe(figh);

end

% write to video
myWriter = VideoWriter(['avi\',name]);
myWriter.FrameRate = 20;
open(myWriter);
writeVideo(myWriter, movieVector);
close(myWriter);

% close
disp('done')