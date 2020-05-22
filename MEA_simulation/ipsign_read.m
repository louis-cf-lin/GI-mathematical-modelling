%ipsign read

clear all;

nx = 23;
nt = 600;

signal = zeros(nt,nx+1);

fid = fopen('output/SW_SEL.txt', 'r');
j = 1;
while 1
    tline = fgetl(fid);
    tline = fgetl(fid);
    if ~ischar(tline)
        break
    elseif length(tline)>20;
            signal(j,:) = str2num(tline);
        j = j + 1;
    else
    end
end
fclose(fid);

k = 1;
for i = 2:1:24
   plot(signal(:,1).*0.001,signal(:,i)) 
   xlim([60 119])
   hold on
end