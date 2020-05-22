clear all;

nx = 8;
ny = 8;
ng = 6;

load init.mat

init_value = zeros(60,ng);
grid_nr = 1:60;
grid_NR = 60;

% 
% 
% for i = 1:size(init_value,2) % IC for each grid point
%     for j = 1:nx
%         for k = 1:ny
%            init_value((j-1)*nx+k,i) = init(1,j,i); 
%         end   
%     end
%     
% end
% 
% grid_NR = nx*ny;
% 
% grid_nr = zeros(ny,nx);
% k = 1;
% for i = 1:ny
%     for j = 1:nx
%         grid_nr(i,j) = k;
%         k = k + 1;
%     end
% end

% beta = zeros(ny,nx);
% 
% for i = 1:nx
%     beta(:,i) = linspace(1.0200e-04,0.980e-04,ny);
% end

fid_0 = fopen('2d_slice_temp.ipmatc', 'r');
fid = fopen('2d_slice.ipmatc', 'w');
tline = fgetl(fid_0);

% offset = 0; % offset value for calibration curve for CMISS sovlers
% Vm_cal= I_stim_cal(offset);

while ischar(tline)
    fprintf(fid, '%s\n', tline);  
    if strcmp(tline, ' Variable V_m is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,1));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');  
    elseif strcmp(tline, ' Variable Ca_c is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,2));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');         
    elseif strcmp(tline, ' Variable Ca_s is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,3));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');  
    elseif strcmp(tline, ' Variable IP_3 is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,4));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');          
     elseif strcmp(tline, ' Variable d_Na is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,5));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');         
     elseif strcmp(tline, ' Variable f_Na is [2]:')
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);  
        tline = fgetl(fid_0);
        fprintf(fid, '%s\n', tline);
        tline = fgetl(fid_0);
        %fprintf(fid, '%s\n', tline);  
        for i = 1:grid_NR        
            fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', i); 
            fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',init_value(i,6));  
        end
        fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');
%    elseif strcmp(tline, ' Variable beta is [2]:')
%     %if strcmp(tline, ' Variable beta is [2]:')
%         tline = fgetl(fid_0);
%         fprintf(fid, '%s\n', tline);  
%         tline = fgetl(fid_0);
%         fprintf(fid, '%s\n', tline);
%         tline = fgetl(fid_0);
%         fprintf(fid, '%s\n', tline);  
%         tline = fgetl(fid_0);
%         fprintf(fid, '%s\n', tline);
%         tline = fgetl(fid_0);
%         %fprintf(fid, '%s\n', tline);  
%         for i = 1:ny
%             for j = 1:nx
%                 fprintf(fid, ' Enter collocation point #s/name [EXIT]: %1.0f\n', grid_nr(i,j)); 
%                 fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',beta(i,j));  
%             end
%         end
%         %fprintf(fid, ' Enter collocation point #s/name [EXIT]: CZ\n'); 
%         %fprintf(fid, ' The value is [ 0.60000E+02]: %6.4E\n',beta(1,1));
%         fprintf(fid, ' Enter collocation point #s/name [EXIT]: 0\n');         
    else
    end
    tline = fgetl(fid_0);
end
fclose(fid);
 
 

 