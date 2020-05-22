% png2avi.m
% create avi-movie from single frames (png-images)
%
% Author: Peng Du, 2 Feb 2010
clear all;

close all;

%fpath_stomach = '/hpc/pdu001/H009/H009_full_dys_antrum/image';			
%fpath_stomach = '/hpc/pdu001/H009/H009_full_2normal/image';	
% fpath_stomach ={'/hpc/pdu001/Stomach_slow_wave_models/virtual_human_stomach_models/VH_normal_ms/image';...
%     '/hpc/pdu001/Stomach_slow_wave_models/virtual_human_stomach_models/VH_antrum_ectopic_ms/image';...
%     '/hpc/pdu001/Stomach_slow_wave_models/virtual_human_stomach_models/VH_slow_corpus_ms/image';...
%     '/hpc/pdu001/Stomach_slow_wave_models/virtual_human_stomach_models/VH_block_ms/image';};

fpath_stomach ={'/hpc/pdu001/2D/CUHK/image/';};


% frames/images:
%fpath= 'd:\tmp\';
%imglist= dir('*.png');				% edit path/filename to match your images' location
t = 0;
imgNo = 401;

% default-parameters:
fps= 30;														% frames per second
%fname= 'animation.avi';						% path/name of movie output file
%codec= 'hfyu';												% video codec (FOURCC), I use HuffYUV ('hfyu') because it is lossless

h = figure;
set(h,'Units', 'points','color','k') 
%set(h,'Position', [50 50 640 480]);         % [left, bottom, width, height]:
%set(h,'Position', [50 50 512*4 512]);         % [left, bottom, width, height]:

%set(h,'Position', [5 5 1024 768]);         % [left, bottom, width, height]:
set(h,'Position', [5 5 512 512]);         % [left, bottom, width, height]:
set(h,'color', 'k');         % [left, bottom, width, height]:

set(gcf,'PaperPositionMode','auto')

v = VideoWriter('2d.avi');
open(v);

dt = 0.01;
%i = 601:-1:1;
i = 0:1:400;
% create movie:
for k= 1:imgNo
	[img_stomach, map]= imread([fpath_stomach{1},'/',int2str(i(k)),'.jpg']);			% get current frame
    image(img_stomach)
    %subplot(1,2,1)
    %imshow(img_stomach);
    %view([180 -90])
    %image(uint8(round(img_stomach-1)))
    %return
    %truesize([1080 1920]);
    axis equal tight off;
    
    t = (k-1)*dt;
%     if t<10
%         time = sprintf('%s%2.1f',' ',t);
%     else
%         time = sprintf('%2.0f',t);
%     end
    
    time = sprintf('%4.2f',t);
     title([time,' s'],'fontsize',20,'color','w');
    
    %if t<10
    %    title(['',time,' s',],'fontsize',24,'color','k');
    %else
       % title([time,' s',],'fontsize',24,'color','k');
    %end
  
    %zoom(1.3)
%     subplot(1,2,2)
%     image(img_torso);   
%     axis equal tight off;
%     title([int2str(t/10),' s']);
    
	%m(k)= getframe(gcf);
% 	if rem(k, 100) == 0
% 		disp([num2str(k) ' frames processed...'])
% %		drawnow
%     end
    t = t + 1;
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);
% create avi:
%movie2avi(m, 'normal_60.avi', 'fps', 30, 'compression', 'none');

% play result:
%movie(m, 1, fps)

% play result:
%movie(m, 1, fps)