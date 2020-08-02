clc
clear

beta_val = [0.000975];
%beta_val = linspace(0,0.002,20);
%eta_val = [0.0389];
eta_val = linspace(0.02,0.023,100);
IP3_val = [0.4778];
%IP3_val = linspace(0,1,20);
show_plot = false;

freq = [];

if show_plot
    figure(1)
end

for k = 1:length(IP3_val)
    for j = 1:length(eta_val)
        for i = 1:length(beta_val)
            [~,~,~,~,peaks] = imtiaz_2002d_noTstart_COR_exported(beta_val(i), eta_val(j), IP3_val(k), show_plot);
            freq = [freq, peaks];
        end
    end
end

figure(2)

% plot(beta_val, freq)
% title('$\beta$ vs. Freq with $\eta$=0.0389 and $IP3$=0.4778', 'Interpreter', 'Latex')
% xlabel('$\beta$', 'Interpreter', 'Latex')
% ylabel('Freq. (cpm)')

plot(eta_val, freq)
title('$\eta$ vs. Freq with $\beta$=0.000975 and $IP3$=0.4778', 'Interpreter', 'Latex')
xlabel('$\eta$', 'Interpreter', 'Latex')
ylabel('Freq. (cpm)')

% plot(IP3_val, freq)
% title('$IP3$ vs. Freq with $\beta$=0.000975 and $\eta$=0.0389', 'Interpreter', 'Latex')
% xlabel('$IP3$', 'Interpreter', 'Latex')
% ylabel('Freq. (cpm)')