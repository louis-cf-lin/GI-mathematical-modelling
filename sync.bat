pscp -r -pw joytheHANDCARRY822 -P 22 MEA_simulation/example_2d.com clin750@hpc5.bioeng.auckland.ac.nz:/people/clin750/MEA_simulation
pscp -r -pw joytheHANDCARRY822 -P 22 MEA_simulation/2d_slice.ipcell clin750@hpc5.bioeng.auckland.ac.nz:/people/clin750/MEA_simulation
pscp -r -pw joytheHANDCARRY822 -P 22 MEA_simulation/mfiles/low-na.ipmatc clin750@hpc5.bioeng.auckland.ac.nz:/people/clin750/MEA_simulation/mfiles

start /wait putty.exe -ssh clin750@hpc5.bioeng.auckland.ac.nz -pw joytheHANDCARRY822 -t -m run_cm.txt

pscp -r -pw joytheHANDCARRY822 -P 22 clin750@hpc5.bioeng.auckland.ac.nz:/people/clin750/MEA_simulation/output/stomach.iphist MEA_simulation/output