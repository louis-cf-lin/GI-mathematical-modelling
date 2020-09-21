% Author: Louis Lin
% This is a Matlab script that reads in processed slow wave data and
% creates a heatmap animation

clear;
close all;
clc;

% resolution
nx = 8;
ny = 8;
nt = 202; % MUST BE CHANGED

% read outputs
addpath('MEA_simulation')
filename = 'stomach.iphist';
Vm = iphistread(filename, 60, 1, nt);

% min and max value of Vm state variable, but not useful for comparing
% between simulations
% cold = min(min(Vm(:,:,1)));
% hot = max(max(Vm(:,:,1)));

bitmap = zeros((nx-1),(ny-1));
name = 'ipmatc-20';
figh = figure;

for k = 1:size(Vm,1)
    % clear current figure
    clf
    % extract time step k for state variable Vm
    yep = Vm(k,:,1);
    % set corners as NaN
    yep = [NaN yep(1:nx-2) NaN yep(nx-1:(nx-1)*ny-2) NaN yep((nx-1)*ny-1:nx*ny-4) NaN];
    % collapse vector into array
    yep = reshape(yep, [nx,ny]).';
    
    % element is average of four corner nodes
    for i = 1:(nx-1)
        for j = 1:(ny-1)
            bitmap(i,j) = (yep(i,j) + yep(i,j+1) + yep(i+1,j) + yep(i+1,j+1))/4;
        end
    end
    
    % plot heat map
    heatmap(bitmap, 'Colormap', cool, 'ColorLimits', [-72 -20]);
    title([name, ' t = ', num2str(k)]);
    
    % capture frame
    movieVector(k) = getframe(figh);
end

% write to video
myWriter = VideoWriter(['avi\',name]);
myWriter.FrameRate = 60;
open(myWriter);
writeVideo(myWriter, movieVector);
close(myWriter);

close
disp('done')
