% Peng Du
% 20 October 2009
% Read extracellular potentials from .exelem files

addpath('output');
addpath('mfile');

time = [0, 598];                 % [start end]
nx = 11;
ny = 1;

ELEC = 1:26;
Phi_E = zeros(length(ELEC),((time(2) - time(1)) + 1));

k = 1;

for i = time(1):1:time(2)
    
    %file_name = sprintf('PHI_E_field%05d.exelem.gz',i)
    file_name = sprintf('field%05d.exelem.gz',i)
    Ve = exread(file_name, nx, ny);
    
    for j = 1:length(ELEC)
        Phi_E(j,k) = Ve(ELEC(j));
        
    end
    k = k + 1;
end

style = {'-','--'};

t = linspace(0,60,length(Phi_E));



h = figure;
set(h,'Units', 'inches') 
set(h,'Position', [2 2 3.5 4.0]);         % [left, bottom, width, height]:

%ELEC_C = 1:13;

ELEC_C = 14:26;



for i = 1:length(ELEC_C)

subplot(2,3,[1 3]);
    
plot(t,Phi_E(ELEC_C(i),:)./100-i,'k');    

hold on

end

ylim([-14 0])
set(gca,'ytick',[])
set(gcf,'PaperPositionMode','auto')
