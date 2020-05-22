clear all;

nx = 45;
ny = 45;
ng = 6;

load init.mat

init_value = init;

grid_NR = nx*ny;

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
    elseif strcmp(tline, ' Variable Ca_2 is [2]:')
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
    else
    end
    tline = fgetl(fid_0);
end
fclose(fid);
 
 

 