clc
clear

G_Na = linspace(0, 16, 10);
G_BK = linspace(0, 2.4, 10);
G_Ca = linspace(0, 12, 50);

tspan = [600000, 660000]; % 60s period after 10 min
show_plot = false;

surface = zeros(length(eta), length(beta));
freq = zeros(1, length(eta) * length(beta));

if show_plot
    figure(1)
end

tic

counter = 1;
for i = 1:length(G_Na)
    for j = 1:length(G_BK)
        for k = 1:length(G_Ca)
            [VOI,STATES,~,~,peaks] = imtiaz_2002d_noTstart_COR_exported(0.000975, 0.0389, G_Na(i), G_BK(j), G_Ca(k), tspan, show_plot);
            freq(counter) = peaks;
            surface(i,j) = peaks;
            counter = counter + 1;
        end
    end
end

fprintf('Average time per iteration: %f s', toc/(length(G_Na) * length(G_BK) * length(G_Ca)));

figure(2)

% plot(beta_val, freq)
% title('$\beta$ vs. Freq with $\eta$=0.0389 and $IP3$=0.4778', 'Interpreter', 'Latex')
% xlabel('$\beta$', 'Interpreter', 'Latex')
% ylabel('Freq. (cpm)')

% plot(eta_val, freq)
% title('$\eta$ vs. Freq with $\beta$=0.000975 and $IP3$=0.4778', 'Interpreter', 'Latex')
% xlabel('$\eta$', 'Interpreter', 'Latex')
% ylabel('Freq. (cpm)')

mesh(beta, eta, surface);