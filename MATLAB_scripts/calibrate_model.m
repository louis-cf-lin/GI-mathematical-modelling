% Script:  calibrate_model.m
% Author:  Louis Lin
% Org:     Auckland Bioengineering Institute
% Purpose: Calibrate the cell model using optimisation heuristics

%% init

clear
clc
close all
addpath('../MEA_simulation')

%% main

fminsearch_call
fminunc_call
ga_call

%% functions

% Nelder-Mead
function fminsearch_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Display', 'iter', 'PlotFcns', @optimplotstepsize); % plots
    [best_guess, obj_value] = fminsearch(@calc_obj_value, initial_guess, options);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

% quasi-Newton
function fminunc_call
    initial_guess = [0.000975, 0.0389];
    options = optimset('Algorithm', 'quasi-newton', 'Display', 'iter'); % solver algorithm and plots
    [best_guess, obj_value] = fminunc(@calc_obj_value, initial_guess, options);
    fprintf('Best guess: beta=%f, eta=%f. Objective value: %f. Time to converge: %fs \n', best_guess(1), best_guess(2), obj_value, toc);
end

% genetic algorithm
function ga_call
    LB = [0.0009, 0.03]; % solution variable lower bounds
    UB = [0.001, 0.05]; % solution variable upper bounds
    n_vars = 2; % number of solutionn variables
    [best_guess, obj_val] = ga(@calc_obj_value, n_vars, [], [], [], [], LB, UB);
    display(best_guess)
    display(obj_val)
end

% objective function
function obj_value = calc_obj_value(initial_guess)
    % solution vars (i.e. parameters) cannot be negative
    if (isempty(initial_guess(initial_guess < 0)))
        [~,~,~,~,freq] = simplified_cell_model(initial_guess(1), initial_guess(2), 8, 1.2, 4, [600000, 690000], false);
        % weighted on solution vars and default value Manhattan distance
        obj_value = abs(17.525 - freq) + abs(0.000975 - initial_guess(1)) + abs(0.0389 - initial_guess(2));
    else
        obj_value = Inf;
    end
end