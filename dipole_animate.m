% Author: Louis Lin
% This is a Matlab script that reads in processed slow wave data and
% creates a heatmap animation

clear;
close all;
clc;

smooth = 0;

% resolution
nx = 8;
ny = 8;
nt = 3001; % period / dt + 1

% read outputs
addpath('MEA_simulation')
addpath('MEA_simulation/output')
filename = 'stomach.iphist';
load('config.mat');

data = iphistread(filename, 61, 1, nt);
Vm = data(:,:,1)';

arranged = NaN(nx, ny, size(Vm,2));
count = 1;
for i = 1:nx
    for j = 1:ny
        if config(i,j) == 0
        else
            arranged(i,j,:) = Vm(config(i,j),:);
            trace(i,j,:) = (arranged(i,j,:)-80)./(-20-80).*-10-count;
            count = count + 1;
        end
    end
end

for i = 1:8
    plot(squeeze(trace(i,4,:)));
    hold on;
    
    % avoid double counting the same peak
    [pks, locs] = findpeaks(squeeze(trace(i,4,:)), 'MinPeakDistance', 10);
    peaks = numel(pks);
    freq = (peaks - 1)/((locs(end) - locs(1))/100)*60;
    disp(freq);
end

bitmap = zeros((nx-1),(ny-1), size(Vm,2));
for i = 1:(nx-1)
    for j = 1:(ny-1)
        bitmap(i,j,:) = (arranged(i,j,:) + arranged(i,j+1,:) + arranged(i+1,j,:) + arranged(i+1,j+1,:))/4;
    end
end



[X,Y] = meshgrid(1:nx-1, 1:ny-1);
[X2,Y2] = meshgrid(1:0.01:nx-1, 1:0.01:ny-1);
name = 'eta';
figh = figure('MenuBar', 'none', ...
       'ToolBar', 'none', ...
       'Color', 'white');
axes('Parent', figh, ...
    'XColor', 'white', ...
    'YColor', 'white', ...
    'Color', 'white');
box off;
set(gcf, 'Position',  [0, 0, 500, 500])

if smooth == 1
    for k = 1:size(data,1)
        % clear current figure
        clf
        % extract time step k for state variable Vm
        yep = data(k,:,1);
        % set corners as NaN
        yep = [0 yep(1:nx-2) 0 yep(nx-1:(nx-1)*ny-2) 0 yep((nx-1)*ny-1:nx*ny-4) 0];
        % collapse vector into array
        yep = reshape(yep, [nx,ny]).';

        % element is average of four corner nodes
        for i = 1:(nx-1)
            for j = 1:(ny-1)
                bitmap(i,j) = (yep(i,j) + yep(i,j+1) + yep(i+1,j) + yep(i+1,j+1))/4;
            end
        end

        outData = interp2(X, Y, bitmap, X2, Y2, 'linear');
        outData(1:100,1:100) = NaN;
        outData(1:100,end-99:end) = NaN;
        outData(end-99:end,1:100) = NaN;
        outData(end-99:end,end-99:end) = NaN;

        % plot heat map
        h = heatmap(outData, ... 
            'Colormap', jet, ... 
            'ColorLimits', [-72 -20], ...
            'MissingDataLabel', '', ... 
            'MissingDataColor', 'white', ...
            'GridVisible', 'off', ...
            'ColorbarVisible', 'off', ...
            'Position', [0.1 0.1 0.8 0.8]);
        title(['t = ', num2str(k/100), 's']);

        Ax = gca;
        Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
        Ax.YDisplayLabels = nan(size(Ax.YDisplayData));

        % capture frame
        movieVector(k) = getframe(figh);

    end
else
     for k = 1:size(Vm,2)
        % clear current figure
        clf

        % plot heat map
        h = heatmap(bitmap(:,:,k), ... 
            'Colormap', jet, ... 
            'ColorLimits', [-72 -20], ...
            'MissingDataLabel', '', ... 
            'MissingDataColor', 'white', ...
            'GridVisible', 'off', ...
            'ColorbarVisible', 'off', ...
            'Position', [0.1 0.1 0.8 0.8]);
        title(['t = ', num2str(k/100), 's']);

        Ax = gca;
        Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
        Ax.YDisplayLabels = nan(size(Ax.YDisplayData));

        % capture frame
        movieVector(k) = getframe(figh);

    end
end


% write to video
myWriter = VideoWriter(['avi\',name]);
myWriter.FrameRate = 20;
open(myWriter);
writeVideo(myWriter, movieVector);
close(myWriter);

% close
disp('done')
