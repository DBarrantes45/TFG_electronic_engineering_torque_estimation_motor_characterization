% -------------------------------------------------------------------------
% MOTOR CHARACTERIZATION FUNCTION
%
% This function calculates the main parameters of the motors by using 
% different tests. Firstly, it calculates stator resistances for both 
% motors and then the stator and rotor reactances, as well as the rotor 
% resistance. Finally, the function calculates magnetizing reactance, 
% power error, and core resistance. The results are summarized in a table.
%
% Outputs:
%   - R_1: Stator resistance (Motor 1 and Motor 2)
%   - R_2: Rotor resistance (Motor 1 and Motor 2)
%   - X_1: Stator reactance (Motor 1 and Motor 2)
%   - X_2: Rotor reactance (Motor 1 and Motor 2)
%   - X_M: Magnetizing reactance (Motor 1 and Motor 2)
%   - R_core: Core resistance (Motor 1 and Motor 2)
%   - Core_losses: Core losses (Motor 1 and Motor 2) (W)
%   - Friction_losses: Friction and windage losses (Motor 1 and Motor 2) (W)
%   - Power_error: Power error (Motor 1 and Motor 2)
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [R_1, R_2, X_1, X_2, X_M, R_core, Core_losses, Friction_losses, Power_error] = motor_characterization()
    clc
    % Calculate stator resistances for both motors
    Stator_resistances = dc_test();

    % Define line currents and voltages (Blocked Rotor Test)
    Line_current_A = [1.850, 1.077];
    Line_current_B = [1.876666667, 1.113333333];
    Line_current_C = [1.87, 1.13];
    Line_voltage_AB = [54.07, 77.63];
    Line_voltage_BC = [55.10, 78.53];
    Line_voltage_CA = [54.10, 77.60];
    Power_factor = [0.716666667, 0.703333333]; % Power Factor

    % Calculate stator and rotor reactances, and rotor resistance
    for i = 1:length(Stator_resistances)
        [R_2(i), X_1(i), X_2(i)] = blocked_rotor_test(Stator_resistances(i), Line_current_A(i), Line_current_B(i), Line_current_C(i), Line_voltage_AB(i), Line_voltage_BC(i), Line_voltage_CA(i), Power_factor(i));
    end

    % Define line currents, voltages, and input power (No Load Test)
    Line_current_A = [1.10, 0.70];
    Line_current_B = [1.12, 0.72];
    Line_current_C = [1.15, 0.72];
    Line_voltage_AB = [209.3333333, 211];
    Line_voltage_BC = [209.6666667, 211];
    Line_voltage_CA = [208.6666667, 210];
    P_in = [65, 49]; % Input Power
    
    % Define other necessary variables
    Stator_reactance = X_1; % Stator Reactance
    Core_losses = [32.11, 14.21]; % Core Losses (W)
    Friction_losses = [6.682, 4.175]; % Friction and Windage Losses (W)

    % Calculate magnetizing reactance, power error, and core resistance
    for i = 1:length(Stator_resistances)
        [X_M(i), Power_error(i), R_core(i)] = no_load_test(Line_current_A(i), Line_current_B(i), Line_current_C(i), Line_voltage_AB(i), Line_voltage_BC(i), Line_voltage_CA(i), P_in(i), Stator_reactance(i), Stator_resistances(i), Core_losses(i), Friction_losses(i), Power_factor(i));
    end
    
    % Calculate inductances
    L_1 = X_1 ./ (2*pi*60);
    L_2 = X_2 ./ (2*pi*60);
    L_M = X_M ./ (2*pi*60);

    % Prepare summary table for display
    values_1 = [Stator_resistances(1), R_2(1), X_1(1), X_2(1), X_M(1), L_1(1), L_2(1), L_M(1), R_core(1), Core_losses(1), Friction_losses(1), Power_error(1)];
    values_2 = [Stator_resistances(2), R_2(2), X_1(2), X_2(2), X_M(2), L_1(2), L_2(2), L_M(2), R_core(2), Core_losses(2), Friction_losses(2), Power_error(2)];
    variable_names = {'R_1', 'R_2', 'X_1', 'X_2', 'X_M', 'L_1', 'L_2', 'L_M', 'R_core', 'Core_losses', 'Friction_losses', 'Power_error'};
    summary_table = cell(10,3);
    summary_table(1,:) = {'Variable','Motor 1','Motor 2'};
    for j = 1:2
        for i = 1:9
            summary_table{i+1,1} = variable_names{i};
            summary_table{i+1,2} = num2str(values_1(i));
            summary_table{i+1,3} = num2str(values_2(i));
        end
    end
    
    % Display parameters
    disp(summary_table);

    % Uncomment to create table in UI
    %tabla = uitable('Data', summary_table, 'ColumnName', {'Variable', 'Motor 1', 'Motor 2'}, 'ColumnWidth', {150, 100, 100}, 'RowName', [], 'Position', [20 20 620 400]);
    %set(tabla, 'ColumnFormat', {'char', 'numeric', 'numeric'});
    %set(tabla, 'ColumnEditable', [false true true]);

end

