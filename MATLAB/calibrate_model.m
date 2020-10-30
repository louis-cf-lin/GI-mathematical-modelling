addpath('../MEA_simulation')

%fminsearch_call
%fminunc_call
ga_call

global try_beta
global try_eta
global store
store = [];
try_beta = [];
try_eta = [];

function fminsearch_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Display', 'iter', 'PlotFcns', @optimplotstepsize);
    tic
    [best_guess, obj_value] = fminsearch(@calc_obj_value, initial_guess, options);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

function fminunc_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Algorithm','quasi-newton','Display', 'iter');
    tic
    [best_guess, obj_value] = fminunc(@calc_obj_value, initial_guess, options);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

function ga_call
    LB = [0.0005, 0.03];
    UB = [0.001, 0.05];
    tic
    [best_guess, obj_val] = ga(@calc_obj_value, 2, [], [], [], [], [0.0009 0.03], [0.001 0.05]);
    toc
    display(best_guess)
    display(obj_val)
end

function obj_value = calc_obj_value(initial_guess)
    disp(initial_guess)
    if (isempty(initial_guess(initial_guess < 0)))
        [~,~,~,~,freq] = imtiaz_2002d_noTstart_COR_exported(initial_guess(1), initial_guess(2), 8, 1.2, 4, [600000, 690000], false);
        obj_value = abs(17.525 - freq) + abs(0.000975 - initial_guess(1)) + abs(0.0389 - initial_guess(2));
    else
        obj_value = Inf;
    end
end