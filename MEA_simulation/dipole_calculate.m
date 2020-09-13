% Author: Peng Du
% Auckland Bioengineering Institute, New Zealand
% This is a Matlab script that reads in processed slow wave data and display
% them in a combined graph.

clear all;
close all;
clc;
%% Add working directories
addpath('output')                                    % contains output
%addpath('ipgrgp')                                    % contains ipgrgp
addpath('mfiles')                                     % contains mfiles

% resolution
nx = 8;
ny = 8;
nt = 2000;

filename = 'stomach.iphist';
Vm = iphistread(filename, 60, 1, nt);

Vm_plot = zeros(size(Vm,1),size(Vm,2));

grid = zeros(8,8);
n = 1;
for i = 1:nx
    for j = 1:ny
        if i == 1 && j == 1
        elseif i == 1 && j == 8
        elseif i == 8 && j == 1    
        elseif i == 8 && j == 8       
        else
            grid(i,j) = n;
            n = n + 1;
        end
    end
end




for i = 1:60
    Vm_plot(:,i) = (Vm(:,i,1)-80)./(-20-80).*-10-i;
end



t = linspace(0,(size(Vm,1)-1)/100,size(Vm,1));



for i = 1:1:length(grid(:,4))
   % plot(15,1,i)
    plot(t,Vm_plot(:,grid(i,4)));
    hold on;
    xlim([0 20])
end

set(gca,'XTick',0:10:20)   
xlabel('Time (s)')
set(gca,'YTickLabel',[])   

set(gcf,'PaperPositionMode','auto')

saveas(gcf, 'dipole_calculate_fig.png')


% break
%print -deps -r600 1d_model
% print -dpng -r600 2d


%init = Vm(269,:,:);

% 
% 
% % % 
% % % filename3 = 'Entrainment_Vm_YCPoh.xls';
% % 
% % %V_BC = xlsread(filename3);
% % 
% % 
% h = figure;
% set(h,'Units', 'inches') 
% set(gcf,'Position', [3 3 3.5 3.5*1.3]);         % [left, bottom, width, height]:
% time = linspace(0,length(Vm_ICC).*0.1,length(Vm_ICC));
% elec = [1 nx];
% style = {'-',':'};
% for i = 1:2
%     subplot(2,1,1)
%     plot(time, Vm_ICC(:,elec(i)), 'color', 'k','linestyle',style{i},'linewidth',1);
%     hold on
%     xlim([305 485])
%     set(gca,'XTick',305:30:485)   
%     set(gca,'XTickLabel',linspace(0,180,length(305:30:485))) 
%     ylim([-80 -30])      
%     ylim([-75 -25])
% 
%     set(gca, 'fontname' ,'arial', 'fontsize', 8)
%     ylabel('V_m (mV)', 'fontname' ,'arial', 'fontsize', 8);
%     xlabel('Time (s)', 'fontname' ,'arial', 'fontsize', 8);  
%     title('Entrained Slow Waves', 'fontname' ,'arial', 'fontsize', 8); 
% 
%     subplot(2,1,2)
%     plot(time, Vm_ICC_decoupled(:,elec(i)), 'color', 'k','linestyle',style{i},'linewidth',1);
%     hold on
%     xlim([303 483])
%     set(gca,'XTick',303:30:483)   
%     set(gca,'XTickLabel',linspace(0,180,length(303:30:483)))
%     ylim([-80 -30])      
%     ylim([-75 -25]) 
%     title('Decoupled Slow Waves', 'fontname' ,'arial', 'fontsize', 8); 
% 
%     set(gca, 'fontname' ,'arial', 'fontsize', 8)
%     ylabel('V_m (mV)', 'fontname' ,'arial', 'fontsize', 8);        
%     xlabel('Time (s)', 'fontname' ,'arial', 'fontsize', 8);    
% end
% %     xlabel('Time (s)', 'fontname' ,'arial', 'fontsize', 8);   
% set(gcf,'PaperPositionMode','auto')
% break
%print -deps -r600 1d_model
% print -dtiff -r300 1d

% [pospeakind1,negpeakind1]=peakdetect(Vm_ICC(:,1));
% [pospeakind2,negpeakind2]=peakdetect(Vm_ICC(:,nx));
% 
% time_dif = [pospeakind2 - pospeakind1].*0.1;

% processing

