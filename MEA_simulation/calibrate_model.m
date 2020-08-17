clc
clear

function calibrate_model
    fminsearch_call
    %fminunc_call
    %ga_call
end

function fminsearch_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);
    tic
    [best_guess, obj_value] = fminsearch(@calc_obj_value, initial_guess);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

function fminunc_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);
    tic
    [best_guess, obj_value] = fminunc(@calc_obj_value, initial_guess, options);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

function ga_call
    LB = [0, 0];
    UB = [0.002, 0.023];
    [best_guess, obj_val] = ga(@calc_obj_value, 2, [],[],[],[], LB, UB);
    display(best_guess)
    display(obj_val)
end

function obj_value = calc_obj_value(initial_guess)
    [~,~,~,~,peaks] = imtiaz_2002d_noTstart_COR_exported(initial_guess(1), initial_guess(2), 8, 1.2, 4, true);
    obj_value = abs(18 - peaks);
end