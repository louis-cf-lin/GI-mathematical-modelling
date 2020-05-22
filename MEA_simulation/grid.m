clear all;

k = 1;

nx = 61;
ny = 61;

grid_nr = zeros(ny,nx);

for i = 1:ny
    for j = 1:nx
        grid_nr(i,j) = k;
        k = k + 1;
    end
end

n = 1;
m = 1;

for i = 1:4:ny
    m = 1;
    for j = 1:4:nx
        elec_nr(n,m) = grid_nr(i,j);
        m = m + 1;
    end
    n = n + 1;
end

% elec = grid_nr(22,:);
% 
% CZ = grid_nr(10:30,10:30);