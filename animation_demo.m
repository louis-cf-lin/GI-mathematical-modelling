clear 
clc
close all

%% Step 1: Generate Data
t = linspace(0, 2*pi, 100);
x = 5*cos(t);
y = 2*sin(t);
z = t;

%% Step 2: Draw/Render the Scenario
figh = figure;

for k=1:length(t)
    %Wipe the slate clean so we are plotting with a blank figure
    clf
    
    %Extract the data at the current time
    t_k = t(k);
    x_k = x(k);
    y_k = y(k);
    z_k = z(k);
    
    %Plot the current location of the particle
    plot3(x_k, y_k, z_k, 'go', 'LineWidth', 3, 'MarkerSize', 15)
    
    %Plot the entire trajectory
    hold on
    plot3(x, y, z, 'b-', 'LineWidth', 2)
    
    %Decorate the plot
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title(['Particle at t = ', num2str(t_k), ' seconds']);
    
    %view([30 35]) % static view
    view([30+20*t_k 35]) % rotating view
    
    %Force MATLAB to draw the image at this point
    %drawnow
    
    %Lower FPS
    %pause(0.2)
    
    %Pretty much does drawnow but also returns a bit map (matrix of all values in current time)
    movieVector(k) = getframe(figh, [10 10 520 400]); %100 bitmaps saved into a single vector ("struct with fields")
end

%% Step 3: Save the Movie
%myWriter = VideoWriter('curve'); %default AVI
myWriter = VideoWriter('curve', 'MPEG-4');
myWriter.FrameRate = 20;

%Open the VideoWriter object, write the movie, and close the file
open(myWriter);
writeVideo(myWriter, movieVector);
close(myWriter);

