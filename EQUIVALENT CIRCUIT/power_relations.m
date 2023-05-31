% -------------------------------------------------------------------------
% POWER_RELATIONS
%
% This function validates the developed equivalent circuit through power relationships.
% It compares the estimated power with manufacturer data knowing the full load torque
% and the full load speed.
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [] = power_relations()
    clc
    
    % Given data
    Core_Resistance = [3851.4647, 8637.8077];
    Core_Losses = [32.11, 14.21];
    Friction_Losses = [6.682, 4.175];
    Magnetization_Reactance = [180.378, 280.88];
    Stator_Resistance = [10.0646, 23.7769];
    Stator_Reactance = [5.8732, 14.4471];
    Rotor_Resistance = [2.0061, 4.8114];
    Rotor_Reactance = [5.8732, 14.4471];
    Line_Current = [0.912, 0.5437];
    Full_Load_Torque = [2.1, 1];
    Full_Load_Speed = [1722, 1722];
    V_phi = 220;

    % Preallocation of result matrices
    results = zeros(2, 3);

    % Loop to analyze both motors
    for Motor_to_Analyze = 1:2
        % Extract motor data
        R_C = Core_Resistance(Motor_to_Analyze);
        P_core = Core_Losses(Motor_to_Analyze);
        P_FandW = Friction_Losses(Motor_to_Analyze);
        X_M = Magnetization_Reactance(Motor_to_Analyze);
        R_1 = Stator_Resistance(Motor_to_Analyze);
        X_1 = Stator_Reactance(Motor_to_Analyze);
        R_2 = Rotor_Resistance(Motor_to_Analyze);
        X_2 = Rotor_Reactance(Motor_to_Analyze);
        I_phi = Line_Current(Motor_to_Analyze);
        T_FL = Full_Load_Torque(Motor_to_Analyze);
        S_FL = Full_Load_Speed(Motor_to_Analyze);
        S_FL_rads = (S_FL * 2 * pi)/60; % Convert to radians

        % Calculate powers
        PO_expected = T_FL * S_FL_rads;
        s = (1800 - S_FL)/(1800);
        Z_2_tilde = R_2/s + 1i*X_2;
        Z_1_tilde = R_1 + 1i*X_1;
        Z_e_tilde = (1/R_C + 1/(1i*X_M) + 1/(Z_2_tilde))^(-1);
        Z_in = Z_1_tilde + Z_e_tilde;
        Z_in_angle = deg2rad(angle(Z_in));
        I_1 = V_phi/Z_in;
        I_1_magnitude = abs(I_1);
        P_in = 3 * V_phi * I_phi * cos(Z_in_angle);
        P_SCL = 3 * I_1_magnitude * R_1;
        E_1 = V_phi - I_1 * Z_1_tilde;
        I_C = E_1 / R_C;
        I_M = E_1 / (1i * X_M);
        I_phi = I_C + I_M;
        I_2 = I_1 - I_phi;
        P_core = 3 * abs(I_C)^2 * R_C;
        P_AG = P_in - P_SCL - P_core;
        P_RCL = 3 * abs(I_2)^2 * R_2;
        P_d = P_AG - P_RCL;
        PO_estimated = P_d - P_FandW;
        
        % Calculate the percentage error
        error = (PO_estimated - PO_expected) / (PO_expected) * 100;

        % Store the results in the matrix
        results(Motor_to_Analyze, :) = [PO_expected, PO_estimated, error];
    end

    % Display results in table form
    disp('Motor | Expected Power | Estimated Power | % Error')
    for i = 1:size(results, 1)
        fprintf('  %d   |      %.2f W      |      %.2f W      |  %.2f %%\n', i, results(i, 1), results(i, 2), results(i, 3));
    end
end

