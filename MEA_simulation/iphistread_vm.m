function Vm = iphistread_vm(filename, nx, ny, nt)

% read iphist file with one variable only

fid = fopen(filename);

Vm = zeros(nt,nx*ny);

k = 1;
w = 1;

%Cai = zeros(401,1);

while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break
    elseif strcmp(char(tline), ' YQS Data:') && w > 17
        for i = 1:(nx*ny)
            tline = char(fgetl(fid));
            tmp = str2num(tline(21:length(tline)));
            Vm(k,i) = tmp;  
        end
        k = k + 1;
    else
    end
    w = w + 1;
end
fclose(fid);