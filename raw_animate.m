clear;
close all;
clc;

addpath('raw');
name = '0_0315_ach-at_0';
load(join(name,'.mat'));

nx = size(config,1);
ny = size(config,2);

Vm = NaN(nx, ny, size(filt_data,2));

for i = 1:nx
    for j = 1:ny
        if config(i,j) == 0
        else
            Vm(i,j,:) = filt_data(config(i,j),:);
        end
    end
end

cold = min(min(filt_data));
hot = max(max(filt_data));

bitmap = zeros(nx-1, ny-1);
figh = figure('MenuBar', 'none', ...
       'ToolBar', 'none', ...
       'Color', 'white');
axes('Parent', figh, ...
    'XColor', 'white', ...
    'YColor', 'white', ...
    'Color', 'white');
box off;
set(gcf, 'Position',  [0, 0, 500, 500])

for k = 1:100:size(filt_data,2)
    % clear current figure
    clf
    % extract time step k for state variable Vm
    yep = Vm(:,:,k);

    % element is average of four corner nodes
    for i = 1:(nx-1)
        for j = 1:(ny-1)
            bitmap(i,j) = (yep(i,j) + yep(i,j+1) + yep(i+1,j) + yep(i+1,j+1))/4;
        end
    end

    % plot heat map
    h = heatmap(bitmap, ... 
        'Colormap', jet, ... 
        'ColorLimits', [cold hot], ...
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
    movieVector(round(k/100)+1) = getframe(figh);

end

% write to video
myWriter = VideoWriter(['avi\',name]);
myWriter.FrameRate = 20;
open(myWriter);
writeVideo(myWriter, movieVector);
close(myWriter);

% close
disp('done')