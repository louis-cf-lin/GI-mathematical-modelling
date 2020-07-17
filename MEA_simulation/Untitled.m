beta_val = [0.000975];
%eta_val = [0.02, 0.021, 0.022, 0.023, 0.04, 0.045, 0.05];
eta_val = linspace(0.02,0.05,20)
IP3_val = [0.4778];
t = tiledlayout(20,1);

[~,~,~,~,peaks] = imtiaz_2002d_noTstart_COR_exported(beta_val, eta_val, IP3_val, t);

%plot(eta_val, peaks)