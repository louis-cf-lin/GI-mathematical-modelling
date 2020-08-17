clc
clear

tspan = [600000, 660000]; % 60s period after 10 min

[VOI,STATES,~,~,peaks] = imtiaz_2002d_noTstart_COR_exported(0.000975, 0.0389, 8, 1.2, 4, tspan, false);

width_start = 3000;
width_end = 5000;
% width_end = size(STATES, 1)

figure(1)
pulsewidth(STATES(width_start:width_end,1), VOI(width_start:width_end)./1000);
width = pulsewidth(STATES(:,1),  VOI./1000);
title('Voltage Pulse Width at Half Max-Amplitude');
xlabel('Time (s)');
ylabel('Voltage (mV)');
fprintf('Mean width: %fs \n', mean(width));

upstroke_start = 3400;
upstroke_end = 3600;
upstroke_percentage = [25 75];

figure(2)
risetime(STATES(upstroke_start:upstroke_end,1), VOI(upstroke_start:upstroke_end)./1000, 'PercentReferenceLevels', upstroke_percentage);
upstroke = risetime(STATES(:,1), VOI./1000);
title(['Voltage Half Upstroke (', num2str(upstroke_percentage(1)), '%-', num2str(upstroke_percentage(2)), '%)']);
xlabel('Time (s)');
ylabel('Voltage (mV)');
fprintf('Mean upstroke: %fs \n', mean(upstroke));

downstroke_start = 1;
downstroke_end = 5000;
downstroke_percentage = [25 75];

figure(3)
falltime(STATES(downstroke_start:downstroke_end,1), VOI(downstroke_start:downstroke_end)./1000, 'PercentReferenceLevels', downstroke_percentage);
downstroke = falltime(STATES(:,1), VOI./1000);
title(['Voltage Half Downstroke (', num2str(downstroke_percentage(1)), '%-', num2str(downstroke_percentage(2)), '%)']);
xlabel('Time (s)');
ylabel('Voltage (mV)');
fprintf('Mean downstroke: %fs \n', mean(downstroke));