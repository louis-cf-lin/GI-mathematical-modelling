function [VOI, STATES, ALGEBRAIC, CONSTANTS, peaks] = imtiaz_2002d_noTstart_COR_exported(beta, eta, G_Na, G_BK, G_Ca, showplot)

    % create plot
    if showplot
        [VOI, STATES, ALGEBRAIC, CONSTANTS, LEGEND_STATES, X_TITLE, peaks] = solveModel(beta, eta, G_Na, G_BK, G_Ca, true);
        %l = legend(LEGEND_STATES);
        %set(l, 'Interpreter', 'Latex');
        xlabel(X_TITLE);
        ylabel('$V_{m}$ (mV)', 'Interpreter', 'Latex');
        title(['($\beta$=',num2str(beta),', $\eta$=',num2str(eta),')'], 'Interpreter', 'Latex');
    else
        [VOI, STATES, ALGEBRAIC, CONSTANTS, LEGEND_STATES, X_TITLE, peaks] = solveModel(beta, eta, G_Na, G_BK, G_Ca, false);
    end
end


function [VOI, STATES, ALGEBRAIC, CONSTANTS, LEGEND_STATES, X_TITLE, peaks] = solveModel(beta, eta, G_Na, G_BK, G_Ca, showplot)
    % Set ALGEBRAIC 
    global algebraicVariableCount
    algebraicVariableCount = 10;
    % Initialise constants and state variables
    [INIT_STATES, CONSTANTS] = initConsts(beta, eta, G_Na, G_BK, G_Ca);

    % Set timespan to solve over
    tspan = [600000, 660000]; % 60s period after 10 min

    % Set numerical accuracy options for ODE solver
    options = odeset('RelTol', 1e-06, 'AbsTol', 1e-06, 'MaxStep', 1);

    % Solve model with ODE solver
    [VOI, STATES] = ode15s(@(VOI, STATES)computeRates(VOI, STATES, CONSTANTS), tspan, INIT_STATES, options);

    % Compute algebraic variables
    [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS);
    ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI);

    % Plot state variables against variable of integration
    [LEGEND_STATES, LEGEND_ALGEBRAIC, X_TITLE, LEGEND_CONSTANTS] = createLegends();
    
    peaks = numel(findpeaks(STATES(:,1)));
    fprintf('beta = %f, eta = %f, G_Na = %f, G_BK = %f, G_Ca = %f: %i cpm \n', beta, eta, G_Na, G_BK, G_Ca, peaks);

    if showplot
        nexttile
        plot(VOI, STATES(:,1)); % only plotting voltage
    end
end

function [LEGEND_STATES, LEGEND_ALGEBRAIC, X_TITLE, LEGEND_CONSTANTS] = createLegends()
    LEGEND_STATES = ''; 
    LEGEND_ALGEBRAIC = ''; 
    LEGEND_CONSTANTS = '';
    X_TITLE = 'time (ms)';
    LEGEND_STATES(:,1) = strpad('$V_{m} (V)$');
    LEGEND_CONSTANTS(:,1) = strpad('$C_{m} (F)$');
    LEGEND_ALGEBRAIC(:,1) = strpad('$I_{Na} (A)$');
    LEGEND_ALGEBRAIC(:,10) = strpad('$I_{Ca} (A)$');
    LEGEND_ALGEBRAIC(:,7) = strpad('$I_{BK} (A)$');
    LEGEND_CONSTANTS(:,2) = strpad('$I_{stim} (A)$');
    LEGEND_CONSTANTS(:,3) = strpad('$Cor (-)$');
    LEGEND_ALGEBRAIC(:,2) = strpad('$d_{inf_{Na}} (-)$');
    LEGEND_CONSTANTS(:,4) = strpad('$tau_{d_{Na}} (A)$');
    %LEGEND_STATES(:,2) = strpad('$d_{Na} (-)$');
    LEGEND_ALGEBRAIC(:,3) = strpad('$f_{inf_{Na}} (-)$');
    LEGEND_CONSTANTS(:,5) = strpad('$tau_{f_{Na}} (s)$');
    %LEGEND_STATES(:,3) = strpad('$f_{Na} (-)$');
    LEGEND_CONSTANTS(:,6) = strpad('$E_{Na} (V)$');
    LEGEND_CONSTANTS(:,7) = strpad('$G_{Na} (F)$');
    %LEGEND_STATES(:,4) = strpad('$Ca_{c} (mM)$');
    LEGEND_ALGEBRAIC(:,5) = strpad('$d_{BK} (-)$');
    LEGEND_CONSTANTS(:,8) = strpad('$E_{K} (V)$');
    LEGEND_CONSTANTS(:,9) = strpad('$G_{max_{BK}} (F)$');
    LEGEND_CONSTANTS(:,10) = strpad('$E_{Ca} (V)$');
    LEGEND_CONSTANTS(:,11) = strpad('$G_{MCa} (F)$');
    LEGEND_CONSTANTS(:,12) = strpad('$q (-)$');
    LEGEND_CONSTANTS(:,13) = strpad('$k_{Ca} (mM)$');
    LEGEND_ALGEBRAIC(:,9) = strpad('$G_{Ca} (F)$');
    %LEGEND_STATES(:,5) = strpad('$Ca_{s} (mM)$');
    %LEGEND_STATES(:,6) = strpad('$IP_{3} (mM)$');
    LEGEND_CONSTANTS(:,14) = strpad('$V_{0} (mM / s)$');
    LEGEND_CONSTANTS(:,15) = strpad('$V_{1} (/ s)$');
    LEGEND_CONSTANTS(:,16) = strpad('$V_{M2} (mM / s)$');
    LEGEND_CONSTANTS(:,17) = strpad('$n (-)$');
    LEGEND_CONSTANTS(:,18) = strpad('$k_{2} (mM)$');
    LEGEND_CONSTANTS(:,19) = strpad('$V_{M3} (mM / s)$');
    LEGEND_CONSTANTS(:,20) = strpad('$w (-)$');
    LEGEND_CONSTANTS(:,21) = strpad('$k_{a} (mM)$');
    LEGEND_CONSTANTS(:,22) = strpad('$m (-)$');
    LEGEND_CONSTANTS(:,23) = strpad('$k_{r} (mM)$');
    LEGEND_CONSTANTS(:,24) = strpad('$o (-)$');
    LEGEND_CONSTANTS(:,25) = strpad('$k_{p} (mM)$');
    LEGEND_ALGEBRAIC(:,4) = strpad('$V_{in} (mM / s)$');
    LEGEND_ALGEBRAIC(:,6) = strpad('$V_{2} (mM / s)$');
    LEGEND_ALGEBRAIC(:,8) = strpad('$V_{3} (mM / s)$');
    LEGEND_CONSTANTS(:,26) = strpad('$k_{f} (/ s)$');
    LEGEND_CONSTANTS(:,27) = strpad('$K (/ s)$');
    LEGEND_CONSTANTS(:,28) = strpad('$beta (mM / s)$');
    LEGEND_CONSTANTS(:,29) = strpad('$eta (\frac{1}{s})$');
    LEGEND_CONSTANTS(:,30) = strpad('$V_{M4} (mM / s)$');
    LEGEND_CONSTANTS(:,31) = strpad('$k_{4} (mM)$');
    LEGEND_CONSTANTS(:,32) = strpad('$u (-)$');
    LEGEND_CONSTANTS(:,33) = strpad('$P_{MV} (mM / s)$');
    LEGEND_CONSTANTS(:,34) = strpad('$k_{v} (V)$');
    LEGEND_CONSTANTS(:,35) = strpad('$r (-)$');
    LEGEND_RATES(:,1) = strpad('$\frac{d}{dt} (V)$');
    LEGEND_RATES(:,2) = strpad('$\frac{dd_{Na}}{dt} (-)$');
    LEGEND_RATES(:,3) = strpad('$\frac{df_{Na}}{dt}(-)$');
    LEGEND_RATES(:,6) = strpad('$\frac{dIP_{3}}{dt} (mM)$');
    LEGEND_RATES(:,5) = strpad('$\frac{{dCa_{s}}{dt} (mM)$');
    LEGEND_RATES(:,4) = strpad('$\frac{dCa_{c}}{dt} (mM)$');
    LEGEND_STATES  = LEGEND_STATES';
    LEGEND_ALGEBRAIC = LEGEND_ALGEBRAIC';
    LEGEND_RATES = LEGEND_RATES';
    LEGEND_CONSTANTS = LEGEND_CONSTANTS';
end

function [STATES, CONSTANTS] = initConsts(beta, eta, G_Na, G_BK, G_Ca)
    VOI = 0; 
    CONSTANTS = []; 
    STATES = []; 
    ALGEBRAIC = [];
    STATES(:,1) = -70.0328; % V_m: membrane voltage  
    CONSTANTS(:,1) = 25; % C_m: membrane capacitance
    CONSTANTS(:,2) = 0; % I_s: stimulus current
    CONSTANTS(:,3) = 4; % Cor
    CONSTANTS(:,4) = 10; % tau_d_Na: Na+ gating time constant
    STATES(:,2) = 0; % d_Na: sodium conductance gate
    CONSTANTS(:,5) = 110; % tau_f_Na: Na+ gating time constant
    STATES(:,3) = 0.9998; % f_Na: sodium conductance gate
    CONSTANTS(:,6) = 80; % E_Na: Na+ reverse potential
    CONSTANTS(:,7) = G_Na; % G_Na: max Na+ conductance
    STATES(:,4) = 0.38498; % Ca_c: Ca2+ cytosol
    CONSTANTS(:,8) = -72; % E_K: K+ reverse potential
    CONSTANTS(:,9) = G_BK; % G_BK: K+ max conductance
    CONSTANTS(:,10) = -20; % E_Ca: Ca2+ reverse potential
    CONSTANTS(:,11) = G_Ca; % G_Ca: Ca2+ max conductance
    CONSTANTS(:,12) = 4; % q: Hill coefficient
    CONSTANTS(:,13) = 1.4; % k_Ca: Half saturation constant for I_Ca
    STATES(:,5) = 2.46238; % Ca_s: Ca2+ intracellular store
    STATES(:,6) = 0.4778; % IP_3: inositol trisphosphate
    CONSTANTS(:,14) = 0.0002145; % V_0: Ca2+ influx into cytosol
    CONSTANTS(:,15) = 0.00022094; % V_1: Ca2+ influx into cytosol due to IP_3
    CONSTANTS(:,16) = 0.0049; % V_M2: max Ca2+ pump into store
    CONSTANTS(:,17) = 2; % n: Hill coefficient
    CONSTANTS(:,18) = 1; % k_2: cytosolic Ca2+ threshold for V_2
    CONSTANTS(:,19) = 0.3224; % V_m3: max Ca2+ pump from store
    CONSTANTS(:,20) = 4; % w: Hill coefficient
    CONSTANTS(:,21) = 0.9; % k_a: cytosolic Ca2+ threshold for V_3
    CONSTANTS(:,22) = 4; % m: Hill coefficient
    CONSTANTS(:,23) = 2; % k_r: cytosolic Ca2+ threshold for V_3
    CONSTANTS(:,24) = 4; % o: Hill coefficient
    CONSTANTS(:,25) = 0.65; % k_p: IP_3 threshold for V_3
    CONSTANTS(:,26) = 0.0000585; % k_f: rate constant
    CONSTANTS(:,27) = 0.0006435; % K: rate constant
    CONSTANTS(:,28) = beta; % beta: IP_3 synthesis constant
    CONSTANTS(:,29) = eta; % eta: linera IP_3 synthesis
    CONSTANTS(:,30) = 0.0004875; % V_M4: max IP_3 nonlinear degradation
    CONSTANTS(:,31) = 0.5; % k_4: half saturation constant
    CONSTANTS(:,32) = 4; % u: Hill coefficient
    CONSTANTS(:,33) = 0.0325; % P_MV: max IP_3 synthesis
    CONSTANTS(:,34) = -68; % k_v: half saturation constant
    CONSTANTS(:,35) = 8; % r: Hill coefficient
    if (isempty(STATES)), warning('Initial values for states not set'); end
end

function [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS)
    
    % set earlier
    global algebraicVariableCount
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
    RATES(:,6) =  CONSTANTS(:,3).*(((CONSTANTS(:,28) -  CONSTANTS(:,29).*STATES(:,6)) - ( CONSTANTS(:,30).*power(STATES(:,6), CONSTANTS(:,32)))./(power(CONSTANTS(:,31), CONSTANTS(:,32))+power(STATES(:,6), CONSTANTS(:,32))))+ CONSTANTS(:,33).*(1.00000 - power(STATES(:,1), CONSTANTS(:,35))./(power(CONSTANTS(:,34), CONSTANTS(:,35))+power(STATES(:,1), CONSTANTS(:,35)))));
    ALGEBRAIC(:,2) = 1.00000./(1.00000+exp((STATES(:,1)+7.00000)./ - 5.00000));
    RATES(:,2) = ( CONSTANTS(:,3).*(ALGEBRAIC(:,2) - STATES(:,2)))./CONSTANTS(:,4);
    ALGEBRAIC(:,3) = 1.00000./(1.00000+exp((STATES(:,1)+37.4000)./4.00000));
    RATES(:,3) = ( CONSTANTS(:,3).*(ALGEBRAIC(:,3) - STATES(:,3)))./CONSTANTS(:,5);
    ALGEBRAIC(:,6) = ( CONSTANTS(:,16).*power(STATES(:,4), CONSTANTS(:,17)))./(power(CONSTANTS(:,18), CONSTANTS(:,17))+power(STATES(:,4), CONSTANTS(:,17)));
    ALGEBRAIC(:,8) = ( (( (( CONSTANTS(:,19).*power(STATES(:,4), CONSTANTS(:,20)))./(power(CONSTANTS(:,21), CONSTANTS(:,20))+power(STATES(:,4), CONSTANTS(:,20)))).*power(STATES(:,5), CONSTANTS(:,22)))./(power(CONSTANTS(:,23), CONSTANTS(:,22))+power(STATES(:,5), CONSTANTS(:,22)))).*power(STATES(:,6), CONSTANTS(:,24)))./(power(CONSTANTS(:,25), CONSTANTS(:,24))+power(STATES(:,6), CONSTANTS(:,24)));
    RATES(:,5) =  CONSTANTS(:,3).*((ALGEBRAIC(:,6) - ALGEBRAIC(:,8)) -  CONSTANTS(:,26).*STATES(:,5));
    ALGEBRAIC(:,4) = CONSTANTS(:,14)+ CONSTANTS(:,15).*STATES(:,6);
    RATES(:,4) =  CONSTANTS(:,3).*(((ALGEBRAIC(:,4) - ALGEBRAIC(:,6))+ALGEBRAIC(:,8)+ CONSTANTS(:,26).*STATES(:,5)) -  CONSTANTS(:,27).*STATES(:,4));
    ALGEBRAIC(:,1) =  CONSTANTS(:,7).*STATES(:,3).*STATES(:,2).*(STATES(:,1) - CONSTANTS(:,6)); % (2) I_Na
    ALGEBRAIC(:,9) = ( CONSTANTS(:,11).*power(STATES(:,4), CONSTANTS(:,12)))./(power(CONSTANTS(:,13), CONSTANTS(:,12))+power(STATES(:,4), CONSTANTS(:,12)));
    ALGEBRAIC(:,10) =  ALGEBRAIC(:,9).*(STATES(:,1) - CONSTANTS(:,10)); % (9) I_Ca
    ALGEBRAIC(:,5) = 1.00000./(1.00000+exp(STATES(:,1)./ - 17.0000 -  2.00000.*log(STATES(:,4)./0.00100000)));
    ALGEBRAIC(:,7) =  CONSTANTS(:,9).*ALGEBRAIC(:,5).*(STATES(:,1) - CONSTANTS(:,8)); % (7) I_BK
    RATES(:,1) = (  - CONSTANTS(:,3).*((ALGEBRAIC(:,1)+ALGEBRAIC(:,10)+ALGEBRAIC(:,7)) - CONSTANTS(:,2)))./CONSTANTS(:,1);
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
    ALGEBRAIC(:,2) = 1.00000./(1.00000+exp((STATES(:,1)+7.00000)./ - 5.00000));
    ALGEBRAIC(:,3) = 1.00000./(1.00000+exp((STATES(:,1)+37.4000)./4.00000));
    ALGEBRAIC(:,6) = ( CONSTANTS(:,16).*power(STATES(:,4), CONSTANTS(:,17)))./(power(CONSTANTS(:,18), CONSTANTS(:,17))+power(STATES(:,4), CONSTANTS(:,17)));
    ALGEBRAIC(:,8) = ( (( (( CONSTANTS(:,19).*power(STATES(:,4), CONSTANTS(:,20)))./(power(CONSTANTS(:,21), CONSTANTS(:,20))+power(STATES(:,4), CONSTANTS(:,20)))).*power(STATES(:,5), CONSTANTS(:,22)))./(power(CONSTANTS(:,23), CONSTANTS(:,22))+power(STATES(:,5), CONSTANTS(:,22)))).*power(STATES(:,6), CONSTANTS(:,24)))./(power(CONSTANTS(:,25), CONSTANTS(:,24))+power(STATES(:,6), CONSTANTS(:,24)));
    ALGEBRAIC(:,4) = CONSTANTS(:,14)+ CONSTANTS(:,15).*STATES(:,6);
    ALGEBRAIC(:,1) =  CONSTANTS(:,7).*STATES(:,3).*STATES(:,2).*(STATES(:,1) - CONSTANTS(:,6));
    ALGEBRAIC(:,9) = ( CONSTANTS(:,11).*power(STATES(:,4), CONSTANTS(:,12)))./(power(CONSTANTS(:,13), CONSTANTS(:,12))+power(STATES(:,4), CONSTANTS(:,12)));
    ALGEBRAIC(:,10) =  (ALGEBRAIC(:,9).*(STATES(:,1) - CONSTANTS(:,10))); % I_Ca
    ALGEBRAIC(:,5) = 1.00000./(1.00000+exp(STATES(:,1)./ - 17.0000 -  2.00000.*log(STATES(:,4)./0.00100000)));
    ALGEBRAIC(:,7) =  CONSTANTS(:,9).*ALGEBRAIC(:,5).*(STATES(:,1) - CONSTANTS(:,8));
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

