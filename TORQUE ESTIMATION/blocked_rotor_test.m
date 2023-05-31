% -------------------------------------------------------------------------
% BLOCKED ROTOR TEST
%
% This function calculates the rotor resistance (R_2) and the stator and rotor reactances 
% (X_1 and X_2) based on various machine measurements and predefined parameters.
%
% Inputs:
%   - R_1: Stator resistance (Ohms)
%   - I_A, I_B, I_C: Phase currents (A)
%   - V_AB, V_BC, V_CA: Line voltages (V)
%   - FP: Power factor
%
% Outputs:
%   - R_2: Rotor resistance (Ohms)
%   - X_1: Stator reactance (Ohms)
%   - X_2: Rotor reactance (Ohms)
%
% Written by Douglas Barrantes Alfaro
% Date: May, 2023
% -------------------------------------------------------------------------

function [R_2, X_1, X_2] = blocked_rotor_test(R_1, I_A, I_B, I_C, V_AB, V_BC, V_CA, FP)
    % Initial variables
    f_test = 60; % Test frequency (Hz)
    f_nominal = 60; % Nominal frequency
    I_L = (I_A + I_B + I_C)/3; % Average line current (A)
    V_L = (V_AB + V_BC + V_CA)/3; % Average line voltage (V)

    % Calculation of rotor resistance
    theta = acos(FP); % Impedance angle theta (degrees)
    Z_RB = V_L / (sqrt(3) * I_L); % Total circuit impedance magnitude
    R_RB = Z_RB * cos(theta); % R_RB calculation
    R_2 = R_RB - R_1; % Rotor resistance calculation

    % Calculation of stator and rotor reactances
    X_tic_RB = Z_RB * sin(theta); % X'RB calculation
    X_RB = (f_nominal)/(f_test) * X_tic_RB; % XRB calculation
    X_1 = 0.5 * X_RB; % Stator reactance
    X_2 = 0.5 * X_RB; % Rotor reactance
end

