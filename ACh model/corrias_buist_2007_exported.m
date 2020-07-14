
function [VOI, STATES, ALGEBRAIC, CONSTANTS] = corrias_buist_2007_exported()
    % This is the "main function".  In Matlab, things work best if you rename this function to match the filename.
   [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel();
end

function [algebraicVariableCount] = getAlgebraicVariableCount()
    % Used later when setting a global variable with the number of algebraic variables.
    % Note: This is not the "main method".
    algebraicVariableCount =34;
end
% There are a total of 14 entries in each of the rate and state variable arrays.
% There are a total of 50 entries in the constant variable array.
%

function [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel()
    % Create ALGEBRAIC of correct size
    global algebraicVariableCount;  algebraicVariableCount = getAlgebraicVariableCount();
    % Initialise constants and state variables
    [INIT_STATES, CONSTANTS] = initConsts;

    % Set timespan to solve over
    tspan = [0, 60000]; % match main script

    % Set numerical accuracy options for ODE solver
    options = odeset('RelTol', 1e-06, 'AbsTol', 1e-06, 'MaxStep', 1);

    % Solve model with ODE solver
    [VOI, STATES] = ode15s(@(VOI, STATES)computeRates(VOI, STATES, CONSTANTS), tspan, INIT_STATES, options);

    % Compute algebraic variables
    [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS);
    ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI);

    % Plot state variables against variable of integration
    [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends();
    figure();
    plot(VOI, STATES);
    xlabel(LEGEND_VOI);
    l = legend(LEGEND_STATES);
    set(l,'Interpreter','none');
end

function [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends()
    LEGEND_STATES = ''; LEGEND_ALGEBRAIC = ''; LEGEND_VOI = ''; LEGEND_CONSTANTS = '';
    LEGEND_VOI = strpad('time in component Time (time_units)');
    LEGEND_CONSTANTS(:,1) = strpad('Ach in component Neural_input (millimolar)');
    LEGEND_CONSTANTS(:,2) = strpad('Gcouple in component Gap_junction (conductance_units)');
    LEGEND_CONSTANTS(:,3) = strpad('T in component Environment (Temperature_units)');
    LEGEND_CONSTANTS(:,4) = strpad('T_exp in component Environment (Temperature_units)');
    LEGEND_CONSTANTS(:,5) = strpad('F in component Environment (F_units)');
    LEGEND_CONSTANTS(:,6) = strpad('R in component Environment (R_units)');
    LEGEND_CONSTANTS(:,7) = strpad('Q10Ca in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,8) = strpad('Q10K in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,9) = strpad('Q10Na in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,10) = strpad('Ca_o in component Environment (millimolar)');
    LEGEND_CONSTANTS(:,11) = strpad('Na_o in component Environment (millimolar)');
    LEGEND_CONSTANTS(:,12) = strpad('K_o in component Environment (millimolar)');
    LEGEND_CONSTANTS(:,33) = strpad('T_correction_Na in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,34) = strpad('T_correction_K in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,35) = strpad('T_correction_Ca in component Environment (dimensionless)');
    LEGEND_CONSTANTS(:,36) = strpad('T_correction_BK in component Environment (conductance_units)');
    LEGEND_CONSTANTS(:,37) = strpad('FoRT in component Environment (Inverse_Voltage_units)');
    LEGEND_CONSTANTS(:,38) = strpad('RToF in component Environment (voltage_units)');
    LEGEND_CONSTANTS(:,13) = strpad('Cm_SM in component SM_Membrane (capacitance_units)');
    LEGEND_CONSTANTS(:,14) = strpad('Vol_SM in component SM_Membrane (volume_units)');
    LEGEND_STATES(:,1) = strpad('Vm_SM in component SM_Membrane (voltage_units)');
    LEGEND_STATES(:,2) = strpad('Ca_i in component SM_Membrane (millimolar)');
    LEGEND_CONSTANTS(:,15) = strpad('Na_i in component SM_Membrane (millimolar)');
    LEGEND_CONSTANTS(:,16) = strpad('K_i in component SM_Membrane (millimolar)');
    LEGEND_ALGEBRAIC(:,31) = strpad('I_Na_SM in component I_Na_SM (current_units)');
    LEGEND_ALGEBRAIC(:,23) = strpad('I_Ltype_SM in component I_Ltype_SM (current_units)');
    LEGEND_ALGEBRAIC(:,26) = strpad('I_LVA_SM in component I_LVA_SM (current_units)');
    LEGEND_ALGEBRAIC(:,30) = strpad('I_kr_SM in component I_kr_SM (current_units)');
    LEGEND_ALGEBRAIC(:,32) = strpad('I_ka_SM in component I_ka_SM (current_units)');
    LEGEND_ALGEBRAIC(:,28) = strpad('I_BK_SM in component I_BK_SM (current_units)');
    LEGEND_ALGEBRAIC(:,34) = strpad('I_NSCC_SM in component I_NSCC_SM (current_units)');
    LEGEND_ALGEBRAIC(:,29) = strpad('I_bk_SM in component I_bk_SM (current_units)');
    LEGEND_ALGEBRAIC(:,24) = strpad('J_CaSR_SM in component J_CaSR_SM (millimolar_per_millisecond)');
    LEGEND_ALGEBRAIC(:,21) = strpad('I_stim in component I_stim (current_units)');
    LEGEND_ALGEBRAIC(:,14) = strpad('local_time in component I_stim (time_units)');
    LEGEND_CONSTANTS(:,17) = strpad('period in component I_stim (time_units)');
    LEGEND_ALGEBRAIC(:,1) = strpad('stim_start in component I_stim (time_units)');
    LEGEND_CONSTANTS(:,18) = strpad('delta_VICC in component I_stim (voltage_units)');
    LEGEND_CONSTANTS(:,19) = strpad('t_ICCpeak in component I_stim (time_units)');
    LEGEND_CONSTANTS(:,20) = strpad('t_ICCplateau in component I_stim (time_units)');
    LEGEND_CONSTANTS(:,21) = strpad('t_ICC_stimulus in component I_stim (time_units)');
    LEGEND_CONSTANTS(:,22) = strpad('V_decay in component I_stim (voltage_units)');
    LEGEND_ALGEBRAIC(:,2) = strpad('d_inf_Ltype_SM in component d_Ltype_SM (dimensionless)');
    LEGEND_CONSTANTS(:,40) = strpad('tau_d_Ltype_SM in component d_Ltype_SM (time_units)');
    LEGEND_STATES(:,3) = strpad('d_Ltype_SM in component d_Ltype_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,3) = strpad('f_inf_Ltype_SM in component f_Ltype_SM (dimensionless)');
    LEGEND_CONSTANTS(:,41) = strpad('tau_f_Ltype_SM in component f_Ltype_SM (time_units)');
    LEGEND_STATES(:,4) = strpad('f_Ltype_SM in component f_Ltype_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,4) = strpad('f_ca_inf_Ltype_SM in component f_ca_Ltype_SM (dimensionless)');
    LEGEND_CONSTANTS(:,42) = strpad('tau_f_ca_Ltype_SM in component f_ca_Ltype_SM (time_units)');
    LEGEND_STATES(:,5) = strpad('f_ca_Ltype_SM in component f_ca_Ltype_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,22) = strpad('E_Ca in component I_Ltype_SM (voltage_units)');
    LEGEND_CONSTANTS(:,23) = strpad('G_max_Ltype in component I_Ltype_SM (conductance_units)');
    LEGEND_CONSTANTS(:,24) = strpad('J_max_CaSR in component J_CaSR_SM (millimolar_per_millisecond)');
    LEGEND_ALGEBRAIC(:,5) = strpad('d_inf_LVA_SM in component d_LVA_SM (dimensionless)');
    LEGEND_CONSTANTS(:,43) = strpad('tau_d_LVA_SM in component d_LVA_SM (time_units)');
    LEGEND_STATES(:,6) = strpad('d_LVA_SM in component d_LVA_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,6) = strpad('f_inf_LVA_SM in component f_LVA_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,15) = strpad('tau_f_LVA_SM in component f_LVA_SM (time_units)');
    LEGEND_STATES(:,7) = strpad('f_LVA_SM in component f_LVA_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,25) = strpad('E_Ca in component I_LVA_SM (voltage_units)');
    LEGEND_CONSTANTS(:,25) = strpad('G_max_LVA in component I_LVA_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,27) = strpad('d_BK_SM in component d_BK_SM (dimensionless)');
    LEGEND_CONSTANTS(:,44) = strpad('E_K in component I_BK_SM (voltage_units)');
    LEGEND_CONSTANTS(:,26) = strpad('G_max_BK in component I_BK_SM (conductance_units)');
    LEGEND_CONSTANTS(:,45) = strpad('E_K in component I_bk_SM (voltage_units)');
    LEGEND_CONSTANTS(:,27) = strpad('G_max_bk in component I_bk_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,7) = strpad('xr1_inf_SM in component xr1_SM (dimensionless)');
    LEGEND_CONSTANTS(:,46) = strpad('tau_xr1_SM in component xr1_SM (time_units)');
    LEGEND_STATES(:,8) = strpad('xr1_SM in component xr1_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,8) = strpad('xr2_inf_SM in component xr2_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,16) = strpad('tau_xr2_SM in component xr2_SM (time_units)');
    LEGEND_STATES(:,9) = strpad('xr2_SM in component xr2_SM (dimensionless)');
    LEGEND_CONSTANTS(:,47) = strpad('E_K in component I_kr_SM (voltage_units)');
    LEGEND_CONSTANTS(:,28) = strpad('G_max_kr_SM in component I_kr_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,9) = strpad('m_inf_Na in component m_Na_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,17) = strpad('tau_m_Na in component m_Na_SM (time_units)');
    LEGEND_STATES(:,10) = strpad('m_Na_SM in component m_Na_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,10) = strpad('h_inf_Na in component h_Na_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,18) = strpad('tau_h_Na in component h_Na_SM (time_units)');
    LEGEND_STATES(:,11) = strpad('h_Na_SM in component h_Na_SM (dimensionless)');
    LEGEND_CONSTANTS(:,48) = strpad('E_Na in component I_Na_SM (voltage_units)');
    LEGEND_CONSTANTS(:,29) = strpad('G_max_Na_SM in component I_Na_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,11) = strpad('xa1_inf_SM in component xa1_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,19) = strpad('tau_xa1_SM in component xa1_SM (time_units)');
    LEGEND_STATES(:,12) = strpad('xa1_SM in component xa1_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,12) = strpad('xa2_inf_SM in component xa2_SM (dimensionless)');
    LEGEND_CONSTANTS(:,49) = strpad('tau_xa2_SM in component xa2_SM (time_units)');
    LEGEND_STATES(:,13) = strpad('xa2_SM in component xa2_SM (dimensionless)');
    LEGEND_CONSTANTS(:,50) = strpad('E_K in component I_ka_SM (voltage_units)');
    LEGEND_CONSTANTS(:,30) = strpad('G_max_ka_SM in component I_ka_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,13) = strpad('m_inf_NSCC_SM in component m_NSCC_SM (dimensionless)');
    LEGEND_ALGEBRAIC(:,20) = strpad('tau_m_NSCC_SM in component m_NSCC_SM (time_units)');
    LEGEND_STATES(:,14) = strpad('m_NSCC_SM in component m_NSCC_SM (dimensionless)');
    LEGEND_CONSTANTS(:,31) = strpad('E_NSCC in component I_NSCC_SM (voltage_units)');
    LEGEND_CONSTANTS(:,32) = strpad('G_max_NSCC_SM in component I_NSCC_SM (conductance_units)');
    LEGEND_ALGEBRAIC(:,33) = strpad('f_ca_NSCC_SM in component I_NSCC_SM (dimensionless)');
    LEGEND_CONSTANTS(:,39) = strpad('rach_NSCC_SM in component I_NSCC_SM (dimensionless)');
    LEGEND_RATES(:,1) = strpad('d/dt Vm_SM in component SM_Membrane (voltage_units)');
    LEGEND_RATES(:,2) = strpad('d/dt Ca_i in component SM_Membrane (millimolar)');
    LEGEND_RATES(:,3) = strpad('d/dt d_Ltype_SM in component d_Ltype_SM (dimensionless)');
    LEGEND_RATES(:,4) = strpad('d/dt f_Ltype_SM in component f_Ltype_SM (dimensionless)');
    LEGEND_RATES(:,5) = strpad('d/dt f_ca_Ltype_SM in component f_ca_Ltype_SM (dimensionless)');
    LEGEND_RATES(:,6) = strpad('d/dt d_LVA_SM in component d_LVA_SM (dimensionless)');
    LEGEND_RATES(:,7) = strpad('d/dt f_LVA_SM in component f_LVA_SM (dimensionless)');
    LEGEND_RATES(:,8) = strpad('d/dt xr1_SM in component xr1_SM (dimensionless)');
    LEGEND_RATES(:,9) = strpad('d/dt xr2_SM in component xr2_SM (dimensionless)');
    LEGEND_RATES(:,10) = strpad('d/dt m_Na_SM in component m_Na_SM (dimensionless)');
    LEGEND_RATES(:,11) = strpad('d/dt h_Na_SM in component h_Na_SM (dimensionless)');
    LEGEND_RATES(:,12) = strpad('d/dt xa1_SM in component xa1_SM (dimensionless)');
    LEGEND_RATES(:,13) = strpad('d/dt xa2_SM in component xa2_SM (dimensionless)');
    LEGEND_RATES(:,14) = strpad('d/dt m_NSCC_SM in component m_NSCC_SM (dimensionless)');
    LEGEND_STATES  = LEGEND_STATES';
    LEGEND_ALGEBRAIC = LEGEND_ALGEBRAIC';
    LEGEND_RATES = LEGEND_RATES';
    LEGEND_CONSTANTS = LEGEND_CONSTANTS';
end

function [STATES, CONSTANTS] = initConsts()
    VOI = 0; CONSTANTS = []; STATES = []; ALGEBRAIC = [];
    CONSTANTS(:,1) = 0.00001;
    CONSTANTS(:,2) = 1.3;
    CONSTANTS(:,3) = 310;
    CONSTANTS(:,4) = 297;
    CONSTANTS(:,5) = 96486;
    CONSTANTS(:,6) = 8314.4;
    CONSTANTS(:,7) = 2.1;
    CONSTANTS(:,8) = 1.365;
    CONSTANTS(:,9) = 2.45;
    CONSTANTS(:,10) = 2.5;
    CONSTANTS(:,11) = 137;
    CONSTANTS(:,12) = 5.9;
    CONSTANTS(:,13) = 77;
    CONSTANTS(:,14) = 3500;
    STATES(:,1) = -69.75;
    STATES(:,2) = 0.00008;
    CONSTANTS(:,15) = 10;
    CONSTANTS(:,16) = 164;
    CONSTANTS(:,17) = 20;
    CONSTANTS(:,18) = 59;
    CONSTANTS(:,19) = 0.098;
    CONSTANTS(:,20) = 7.582;
    CONSTANTS(:,21) = 10;
    CONSTANTS(:,22) = 37.25;
    STATES(:,3) = 0;
    STATES(:,4) = 0.95;
    STATES(:,5) = 1;
    CONSTANTS(:,23) = 65;
    CONSTANTS(:,24) = 317.05;
    STATES(:,6) = 0.02;
    STATES(:,7) = 0.99;
    CONSTANTS(:,25) = 0.18;
    CONSTANTS(:,26) = 45.7;
    CONSTANTS(:,27) = 0.0144;
    STATES(:,8) = 0;
    STATES(:,9) = 0.82;
    CONSTANTS(:,28) = 35;
    STATES(:,10) = 0.005;
    STATES(:,11) = 0.05787;
    CONSTANTS(:,29) = 3;
    STATES(:,12) = 0.00414;
    STATES(:,13) = 0.72;
    CONSTANTS(:,30) = 9;
    STATES(:,14) = 0;
    CONSTANTS(:,31) = -28;
    CONSTANTS(:,32) = 50;
    CONSTANTS(:,33) = power(CONSTANTS(:,9), (CONSTANTS(:,3) - CONSTANTS(:,4))./10.0000);
    CONSTANTS(:,34) = power(CONSTANTS(:,8), (CONSTANTS(:,3) - CONSTANTS(:,4))./10.0000);
    CONSTANTS(:,35) = power(CONSTANTS(:,7), (CONSTANTS(:,3) - CONSTANTS(:,4))./10.0000);
    CONSTANTS(:,36) =  1.10000.*(CONSTANTS(:,3) - CONSTANTS(:,4));
    CONSTANTS(:,37) = CONSTANTS(:,5)./( CONSTANTS(:,6).*CONSTANTS(:,3));
    CONSTANTS(:,38) = ( CONSTANTS(:,6).*CONSTANTS(:,3))./CONSTANTS(:,5);
    CONSTANTS(:,39) = 1.00000./(1.00000+0.0100000./CONSTANTS(:,1));
    CONSTANTS(:,40) =  CONSTANTS(:,35).*0.000470000;
    CONSTANTS(:,41) =  CONSTANTS(:,35).*0.0860000;
    CONSTANTS(:,42) =  CONSTANTS(:,35).*0.00200000;
    CONSTANTS(:,43) =  CONSTANTS(:,35).*0.00300000;
    CONSTANTS(:,44) =  CONSTANTS(:,38).*log(CONSTANTS(:,12)./CONSTANTS(:,16));
    CONSTANTS(:,45) =  CONSTANTS(:,38).*log(CONSTANTS(:,12)./CONSTANTS(:,16));
    CONSTANTS(:,46) =  CONSTANTS(:,34).*0.0800000;
    CONSTANTS(:,47) =  CONSTANTS(:,38).*log(CONSTANTS(:,12)./CONSTANTS(:,16));
    CONSTANTS(:,48) =  CONSTANTS(:,38).*log(CONSTANTS(:,11)./CONSTANTS(:,15));
    CONSTANTS(:,49) =  CONSTANTS(:,34).*0.0900000;
    CONSTANTS(:,50) =  CONSTANTS(:,38).*log(CONSTANTS(:,12)./CONSTANTS(:,16));
    if (isempty(STATES)), warning('Initial values for states not set');, end
end

function [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS)
    global algebraicVariableCount;
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        ALGEBRAIC = zeros(1, algebraicVariableCount);
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        ALGEBRAIC = zeros(statesRowCount, algebraicVariableCount);
        RATES = zeros(statesRowCount, statesColumnCount);
        utilOnes = ones(statesRowCount, 1);
    end
    ALGEBRAIC(:,2) = 1.00000./(1.00000+exp((STATES(:,1)+17.0000)./ - 4.30000));
    RATES(:,3) = (ALGEBRAIC(:,2) - STATES(:,3))./CONSTANTS(:,40);
    ALGEBRAIC(:,3) = 1.00000./(1.00000+exp((STATES(:,1)+43.0000)./8.90000));
    RATES(:,4) = (ALGEBRAIC(:,3) - STATES(:,4))./CONSTANTS(:,41);
    ALGEBRAIC(:,4) = 1.00000 - 1.00000./(1.00000+exp(((STATES(:,2) - 8.99900e-05) - 0.000214000)./ - 1.31000e-05));
    RATES(:,5) = (ALGEBRAIC(:,4) - STATES(:,5))./CONSTANTS(:,42);
    ALGEBRAIC(:,5) = 1.00000./(1.00000+exp((STATES(:,1)+27.5000)./ - 10.9000));
    RATES(:,6) = (ALGEBRAIC(:,5) - STATES(:,6))./CONSTANTS(:,43);
    ALGEBRAIC(:,7) = 1.00000./(1.00000+exp((STATES(:,1)+27.0000)./ - 5.00000));
    RATES(:,8) = (ALGEBRAIC(:,7) - STATES(:,8))./CONSTANTS(:,46);
    ALGEBRAIC(:,12) = 0.100000+0.900000./(1.00000+exp((STATES(:,1)+65.0000)./6.20000));
    RATES(:,13) = (ALGEBRAIC(:,12) - STATES(:,13))./CONSTANTS(:,49);
    ALGEBRAIC(:,6) = 1.00000./(1.00000+exp((STATES(:,1)+15.8000)./7.00000));
    ALGEBRAIC(:,15) =  CONSTANTS(:,35).*0.00758000.*exp( STATES(:,1).*0.00817000);
    RATES(:,7) = (ALGEBRAIC(:,6) - STATES(:,7))./ALGEBRAIC(:,15);
    ALGEBRAIC(:,8) = 0.200000+0.800000./(1.00000+exp((STATES(:,1)+58.0000)./10.0000));
    ALGEBRAIC(:,16) =  CONSTANTS(:,34).*( - 0.707000+ 1.48100.*exp((STATES(:,1)+36.0000)./95.0000));
    RATES(:,9) = (ALGEBRAIC(:,8) - STATES(:,9))./ALGEBRAIC(:,16);
    ALGEBRAIC(:,9) = 1.00000./(1.00000+exp((STATES(:,1)+47.0000)./ - 4.80000));
    ALGEBRAIC(:,17) =  CONSTANTS(:,33).*( STATES(:,1).* - 0.0170000.*0.00100000+0.000440000);
    RATES(:,10) = (ALGEBRAIC(:,9) - STATES(:,10))./ALGEBRAIC(:,17);
    ALGEBRAIC(:,10) = 1.00000./(1.00000+exp((STATES(:,1)+78.0000)./3.00000));
    ALGEBRAIC(:,18) =  CONSTANTS(:,33).*( STATES(:,1).* - 0.250000.*0.00100000+0.00550000);
    RATES(:,11) = (ALGEBRAIC(:,10) - STATES(:,11))./ALGEBRAIC(:,18);
    ALGEBRAIC(:,11) = 1.00000./(1.00000+exp((STATES(:,1)+26.5000)./ - 7.90000));
    ALGEBRAIC(:,19) =  CONSTANTS(:,34).*(0.0318000+ 0.175000.*exp(  - 0.500000.*power((STATES(:,1)+44.4000)./22.3000, 2.00000)));
    RATES(:,12) = (ALGEBRAIC(:,11) - STATES(:,12))./ALGEBRAIC(:,19);
    ALGEBRAIC(:,13) = 1.00000./(1.00000+exp((STATES(:,1)+25.0000)./ - 20.0000));
    ALGEBRAIC(:,20) =  (1.00000./(1.00000+exp((STATES(:,1)+66.0000)./ - 26.0000))).*0.150000;
    RATES(:,14) = (ALGEBRAIC(:,13) - STATES(:,14))./ALGEBRAIC(:,20);
    ALGEBRAIC(:,22) =  0.500000.*CONSTANTS(:,38).*log(CONSTANTS(:,10)./STATES(:,2));
    ALGEBRAIC(:,23) =  CONSTANTS(:,23).*STATES(:,4).*STATES(:,3).*STATES(:,5).*(STATES(:,1) - ALGEBRAIC(:,22));
    ALGEBRAIC(:,25) =  0.500000.*CONSTANTS(:,38).*log(CONSTANTS(:,10)./STATES(:,2));
    ALGEBRAIC(:,26) =  CONSTANTS(:,25).*STATES(:,7).*STATES(:,6).*(STATES(:,1) - ALGEBRAIC(:,25));
    ALGEBRAIC(:,24) =  CONSTANTS(:,24).*power( STATES(:,2).*1.00000, 1.34000);
    RATES(:,2) = (  - 1.00000.*ALGEBRAIC(:,23)+  - 1.00000.*ALGEBRAIC(:,26))./( 2.00000.*0.00100000.*CONSTANTS(:,5).*CONSTANTS(:,14))+  - 1.00000.*ALGEBRAIC(:,24);
    ALGEBRAIC(:,31) =  CONSTANTS(:,29).*STATES(:,11).*STATES(:,10).*(STATES(:,1) - CONSTANTS(:,48));
    ALGEBRAIC(:,30) =  CONSTANTS(:,28).*STATES(:,8).*STATES(:,9).*(STATES(:,1) - CONSTANTS(:,47));
    ALGEBRAIC(:,32) =  CONSTANTS(:,30).*STATES(:,12).*STATES(:,13).*(STATES(:,1) - CONSTANTS(:,50));
    ALGEBRAIC(:,27) = 1.00000./(1.00000+exp(STATES(:,1)./ - 17.0000 -  2.00000.*log(STATES(:,2)./0.00100000)));
    ALGEBRAIC(:,28) =  (CONSTANTS(:,26)+CONSTANTS(:,36)).*ALGEBRAIC(:,27).*(STATES(:,1) - CONSTANTS(:,44));
    ALGEBRAIC(:,33) = 1.00000./(1.00000+power(STATES(:,2)./0.000200000,  - 4.00000));
    ALGEBRAIC(:,34) =  CONSTANTS(:,32).*STATES(:,14).*ALGEBRAIC(:,33).*CONSTANTS(:,39).*(STATES(:,1) - CONSTANTS(:,31));
    ALGEBRAIC(:,29) =  CONSTANTS(:,27).*(STATES(:,1) - CONSTANTS(:,45));
    ALGEBRAIC(:,1) = piecewise({VOI> CONSTANTS(:,17).*1.00000&VOI<= CONSTANTS(:,17).*2.00000,  CONSTANTS(:,17).*1.00000 , VOI> CONSTANTS(:,17).*2.00000&VOI<= CONSTANTS(:,17).*3.00000,  CONSTANTS(:,17).*2.00000 , VOI> CONSTANTS(:,17).*3.00000&VOI<= CONSTANTS(:,17).*4.00000,  CONSTANTS(:,17).*3.00000 , VOI> CONSTANTS(:,17).*4.00000&VOI<= CONSTANTS(:,17).*5.00000,  CONSTANTS(:,17).*4.00000 }, 0.000000);
    ALGEBRAIC(:,14) = VOI - (ALGEBRAIC(:,1)+CONSTANTS(:,19));
    ALGEBRAIC(:,21) = piecewise({ALGEBRAIC(:,14)<CONSTANTS(:,19),  CONSTANTS(:,2).*CONSTANTS(:,18) , ALGEBRAIC(:,14)>=CONSTANTS(:,19)&ALGEBRAIC(:,14)<=CONSTANTS(:,20), ( CONSTANTS(:,2).*CONSTANTS(:,18).*1.00000)./(1.00000+exp((ALGEBRAIC(:,14) - 8.00000)./1.00000)) , ALGEBRAIC(:,14)>CONSTANTS(:,20)&ALGEBRAIC(:,14)<CONSTANTS(:,21), ( CONSTANTS(:,2).*CONSTANTS(:,22).*1.00000)./(1.00000+exp((ALGEBRAIC(:,14) - 8.00000)./0.150000)) }, 0.000000);
    RATES(:,1) =  ((  - 1.00000.*1.00000)./CONSTANTS(:,13)).*(ALGEBRAIC(:,31)+ALGEBRAIC(:,23)+ALGEBRAIC(:,26)+ALGEBRAIC(:,30)+ALGEBRAIC(:,32)+ALGEBRAIC(:,28)+ALGEBRAIC(:,34)+ALGEBRAIC(:,29)+  - 1.00000.*ALGEBRAIC(:,21));
   RATES = RATES';
end

% Calculate algebraic variables
function ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI)
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        utilOnes = ones(statesRowCount, 1);
    end
    ALGEBRAIC(:,2) = 1.00000./(1.00000+exp((STATES(:,1)+17.0000)./ - 4.30000));
    ALGEBRAIC(:,3) = 1.00000./(1.00000+exp((STATES(:,1)+43.0000)./8.90000));
    ALGEBRAIC(:,4) = 1.00000 - 1.00000./(1.00000+exp(((STATES(:,2) - 8.99900e-05) - 0.000214000)./ - 1.31000e-05));
    ALGEBRAIC(:,5) = 1.00000./(1.00000+exp((STATES(:,1)+27.5000)./ - 10.9000));
    ALGEBRAIC(:,7) = 1.00000./(1.00000+exp((STATES(:,1)+27.0000)./ - 5.00000));
    ALGEBRAIC(:,12) = 0.100000+0.900000./(1.00000+exp((STATES(:,1)+65.0000)./6.20000));
    ALGEBRAIC(:,6) = 1.00000./(1.00000+exp((STATES(:,1)+15.8000)./7.00000));
    ALGEBRAIC(:,15) =  CONSTANTS(:,35).*0.00758000.*exp( STATES(:,1).*0.00817000);
    ALGEBRAIC(:,8) = 0.200000+0.800000./(1.00000+exp((STATES(:,1)+58.0000)./10.0000));
    ALGEBRAIC(:,16) =  CONSTANTS(:,34).*( - 0.707000+ 1.48100.*exp((STATES(:,1)+36.0000)./95.0000));
    ALGEBRAIC(:,9) = 1.00000./(1.00000+exp((STATES(:,1)+47.0000)./ - 4.80000));
    ALGEBRAIC(:,17) =  CONSTANTS(:,33).*( STATES(:,1).* - 0.0170000.*0.00100000+0.000440000);
    ALGEBRAIC(:,10) = 1.00000./(1.00000+exp((STATES(:,1)+78.0000)./3.00000));
    ALGEBRAIC(:,18) =  CONSTANTS(:,33).*( STATES(:,1).* - 0.250000.*0.00100000+0.00550000);
    ALGEBRAIC(:,11) = 1.00000./(1.00000+exp((STATES(:,1)+26.5000)./ - 7.90000));
    ALGEBRAIC(:,19) =  CONSTANTS(:,34).*(0.0318000+ 0.175000.*exp(  - 0.500000.*power((STATES(:,1)+44.4000)./22.3000, 2.00000)));
    ALGEBRAIC(:,13) = 1.00000./(1.00000+exp((STATES(:,1)+25.0000)./ - 20.0000));
    ALGEBRAIC(:,20) =  (1.00000./(1.00000+exp((STATES(:,1)+66.0000)./ - 26.0000))).*0.150000;
    ALGEBRAIC(:,22) =  0.500000.*CONSTANTS(:,38).*log(CONSTANTS(:,10)./STATES(:,2));
    ALGEBRAIC(:,23) =  CONSTANTS(:,23).*STATES(:,4).*STATES(:,3).*STATES(:,5).*(STATES(:,1) - ALGEBRAIC(:,22));
    ALGEBRAIC(:,25) =  0.500000.*CONSTANTS(:,38).*log(CONSTANTS(:,10)./STATES(:,2));
    ALGEBRAIC(:,26) =  CONSTANTS(:,25).*STATES(:,7).*STATES(:,6).*(STATES(:,1) - ALGEBRAIC(:,25));
    ALGEBRAIC(:,24) =  CONSTANTS(:,24).*power( STATES(:,2).*1.00000, 1.34000);
    ALGEBRAIC(:,31) =  CONSTANTS(:,29).*STATES(:,11).*STATES(:,10).*(STATES(:,1) - CONSTANTS(:,48));
    ALGEBRAIC(:,30) =  CONSTANTS(:,28).*STATES(:,8).*STATES(:,9).*(STATES(:,1) - CONSTANTS(:,47));
    ALGEBRAIC(:,32) =  CONSTANTS(:,30).*STATES(:,12).*STATES(:,13).*(STATES(:,1) - CONSTANTS(:,50));
    ALGEBRAIC(:,27) = 1.00000./(1.00000+exp(STATES(:,1)./ - 17.0000 -  2.00000.*log(STATES(:,2)./0.00100000)));
    ALGEBRAIC(:,28) =  (CONSTANTS(:,26)+CONSTANTS(:,36)).*ALGEBRAIC(:,27).*(STATES(:,1) - CONSTANTS(:,44));
    ALGEBRAIC(:,33) = 1.00000./(1.00000+power(STATES(:,2)./0.000200000,  - 4.00000)); % STATES(:,2) is Ca_i, and this equation is h_Ca
    ALGEBRAIC(:,34) =  CONSTANTS(:,32).*STATES(:,14).*ALGEBRAIC(:,33).*CONSTANTS(:,39).*(STATES(:,1) - CONSTANTS(:,31));
    ALGEBRAIC(:,29) =  CONSTANTS(:,27).*(STATES(:,1) - CONSTANTS(:,45));
    ALGEBRAIC(:,1) = piecewise({VOI> CONSTANTS(:,17).*1.00000&VOI<= CONSTANTS(:,17).*2.00000,  CONSTANTS(:,17).*1.00000 , VOI> CONSTANTS(:,17).*2.00000&VOI<= CONSTANTS(:,17).*3.00000,  CONSTANTS(:,17).*2.00000 , VOI> CONSTANTS(:,17).*3.00000&VOI<= CONSTANTS(:,17).*4.00000,  CONSTANTS(:,17).*3.00000 , VOI> CONSTANTS(:,17).*4.00000&VOI<= CONSTANTS(:,17).*5.00000,  CONSTANTS(:,17).*4.00000 }, 0.000000);
    ALGEBRAIC(:,14) = VOI - (ALGEBRAIC(:,1)+CONSTANTS(:,19));
    ALGEBRAIC(:,21) = piecewise({ALGEBRAIC(:,14)<CONSTANTS(:,19),  CONSTANTS(:,2).*CONSTANTS(:,18) , ALGEBRAIC(:,14)>=CONSTANTS(:,19)&ALGEBRAIC(:,14)<=CONSTANTS(:,20), ( CONSTANTS(:,2).*CONSTANTS(:,18).*1.00000)./(1.00000+exp((ALGEBRAIC(:,14) - 8.00000)./1.00000)) , ALGEBRAIC(:,14)>CONSTANTS(:,20)&ALGEBRAIC(:,14)<CONSTANTS(:,21), ( CONSTANTS(:,2).*CONSTANTS(:,22).*1.00000)./(1.00000+exp((ALGEBRAIC(:,14) - 8.00000)./0.150000)) }, 0.000000);
end

% Compute result of a piecewise function
function x = piecewise(cases, default)
    set = [0];
    for i = 1:2:length(cases)
        if (length(cases{i+1}) == 1)
            x(cases{i} & ~set,:) = cases{i+1};
        else
            x(cases{i} & ~set,:) = cases{i+1}(cases{i} & ~set);
        end
        set = set | cases{i};
        if(set), break, end
    end
    if (length(default) == 1)
        x(~set,:) = default;
    else
        x(~set,:) = default(~set);
    end
end

% Pad out or shorten strings to a set length
function strout = strpad(strin)
    req_length = 160;
    insize = size(strin,2);
    if insize > req_length
        strout = strin(1:req_length);
    else
        strout = [strin, blanks(req_length - insize)];
    end
end

