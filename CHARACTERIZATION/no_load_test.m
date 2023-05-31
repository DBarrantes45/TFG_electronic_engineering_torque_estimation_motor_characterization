% -------------------------------------------------------------------------
% NO LOAD TEST
%
% This function calculates the magnetizing reactance (X_M), power error
% (power_error), and core resistance (R_core) from various machine measurements
% and predefined parameters.
%
% Inputs:
%   - I_A, I_B, I_C: Line currents A, B, and C (A)
%   - V_AB, V_BC, V_CA: Line voltages AB, BC, and CA (V)
%   - P_in: Input power (W)
%   - X_1: Stator reactance (ohms)
%   - R_1: Stator resistance (ohms)
%   - P_core: Core losses (W)
%   - P_FyR: Friction and windage losses (W)
%   - FP: Power factor
%
% Outputs:
%   - X_M: Magnetizing reactance (ohms)
%   - power_error: Power error
%   - R_core: Core resistance (ohms)
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [X_M, power_error, R_core] = no_load_test(I_A, I_B, I_C, V_AB, V_BC, V_CA, P_in, X_1, R_1, P_core, P_FyR, FP)

    % Initial Variables
    % Average line current measured (A)
    I_L = (I_A + I_B + I_C) / 3;
    % Average voltages measured (V)
    V_L = (V_AB + V_BC + V_CA) / 3;
    % Calculation of V_phi (nominal voltage 220V)
    V_phi = V_L;
    
    % Calculation of magnetizing reactance
    Z_eq = V_phi / I_L;
    X_M = Z_eq - X_1;
    
    % Checking measured variables
    % Calculation of P_SCL
    P_SCL = 3 * I_L^2 * R_1;
    P_in_estimated = P_core + P_SCL + P_FyR;
    power_error = (P_in_estimated - P_in) / P_in;
    
    % Calculation of core resistance
    % Calculation of the stator impedance
    Z_1 = R_1 + 1i * X_1;
    % Calculation of theta
    theta = acos(FP);
    % Calculation of I_1
    phase_rad = deg2rad(theta);
    I_1 = I_L * (cos(phase_rad) + 1i * sin(theta));
    % Calculation of E_1
    E_1 = V_phi - (I_1 * Z_1);
    E_1 = abs(E_1);
    % Core resistance
    R_core = 3 * E_1^2 / P_core;

end

