pscp -r -pw password -P 22 MEA_simulation/example_2d.com upi@hpc5.bioeng.auckland.ac.nz:/people/upi/MEA_simulation
pscp -r -pw password -P 22 MEA_simulation/2d_slice.ipcell upi@hpc5.bioeng.auckland.ac.nz:/people/upi/MEA_simulation

start /wait putty.exe -ssh upi@hpc5.bioeng.auckland.ac.nz -pw password -t -m run_cm.txt

pscp -r -pw password -P 22 upi@hpc5.bioeng.auckland.ac.nz:/people/upi/MEA_simulation/output/stomach.iphist MEA_simulation/output