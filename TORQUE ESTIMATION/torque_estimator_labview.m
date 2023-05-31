% -------------------------------------------------------------------------
% TORQUE ESTIMATOR FOR LABVIEW
%
% This function estimates the torque of an induction motor based on real-time
% measurements of speed and voltage. The obtained values are particularly
% useful for implementation in real-time control environments like LabVIEW.
%
% Input parameters:
% - Motor_to_analyze: Index of the motor to analyze
% - n_motor: Motor speed in RPM
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [torque] = torque_estimator_labview(Motor_to_analyze, n_motor, V_phi)

    % ---> EXTRACT THE REQUIRED VARIABLES

    %[R_stator, R_rotor, X_stator, X_rotor, X_magnetization, Core_resistance, Core_losses, Friction_losses, power_error] = motor_characterization();

    % ---> DECLARE VARIABLES
    % Core resistance
    Core_resistance = [3851.4647, 8637.8077];
    R_C = Core_resistance(Motor_to_analyze);
    % Core losses (W)
    Core_losses = [32.11, 14.21];
    P_core = Core_losses(Motor_to_analyze);
    % Friction and windage losses (W)
    Friction_losses = [6.682, 4.175];
    P_Friction = Friction_losses(Motor_to_analyze);
    % Magnetization reactance
    X_magnetization = [180.378, 280.88];
    X_M = X_magnetization(Motor_to_analyze);
    % Stator resistance
    R_stator = [10.0646, 23.7769];
    R_1 = R_stator(Motor_to_analyze);
    % Stator inductance
    X_stator = [5.8732, 14.4471];
    X_1 = X_stator(Motor_to_analyze);
    % Breakdown Power
    B_P = [2.52, 2.27];
    B_P = B_P(Motor_to_analyze);
    % Rotor resistance
    R_rotor = [2.0061, 4.8114];
    R_2 = R_rotor(Motor_to_analyze);
    % Rotor inductance
    X_rotor = [5.8732, 14.4471];
    X_2 = X_rotor(Motor_to_analyze);
    % Initial losses
    Initial_losses = [0, 0];

    % Synchronous speed (RPM)
    n_synchronous = 1800;
    % Synchronous speed (rad/s)
    w_synchronous = (n_synchronous * 2 * pi) / 60;
    % Motor speed (rad/s)
    w_motor = (n_motor * 2 * pi) / 60;
    % Slip
    s = (w_synchronous - w_motor) / w_synchronous;

    % ---> CALCULATING THEVENIN VOLTAGE
    V_TH = V_phi * (X_M * R_C) / sqrt((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % ---> CALCULATING THEVENIN IMPEDANCE
    % Thevenin resistance
    R_TH = (X_M * R_C * R_1 * (-R_C * R_1 + X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    % Thevenin reactance
    X_TH = (X_M * R_C * R_1 * (R_C * R_1 - X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % ---> CALCULATING CURRENT I_2
    I_2 = V_TH / sqrt((R_TH + R_2 / s)^2 + (X_TH + X_2)^2);

    % ---> CALCULATING AIR GAP POWER
    P_AG = 3 / B_P * I_2^2 * R_2 / s;

    % ---> CALCULATING INDUCED TORQUE
    T_ind = P_AG / w_synchronous;

    % ---> CALCULATING LOAD TORQUE
    % Rotational losses
    P_rot = P_Friction;
    % Torque losses
    T_losses = (P_rot * (1 - s)) / w_motor;
    % Load torque (N*m)
    if T_losses >= Initial_losses(Motor_to_analyze)
        T_load = T_ind - T_losses;
    else
        T_load = T_ind - Initial_losses(Motor_to_analyze);
    end

    torque = T_load;

end
