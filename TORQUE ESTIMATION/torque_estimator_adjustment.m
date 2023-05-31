% -------------------------------------------------------------------------
% TORQUE ESTIMATOR FOR INDUCTION MOTOR
%
% This function estimates the torque of an induction motor based on the
% provided motor characteristics and the motor speed. It calculates the
% torque considering factors such as core resistance, losses, reactance,
% and slip. Additionally, it includes adjustment variables BDT and LRT to
% control the maximum torque peak and the pull-up torque as the motor speed
% increases.
%
% Inputs:
%   - Motor_to_analyze: Motor identifier (1 or 2)
%   - n_motor: Motor speed in rpm
%
% Output:
%   - torque: Estimated torque in Nm
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [torque] = torque_estimator_adjustment(Motor_to_analyze, n_motor)
    clc;

    % Extract necessary variables
    [R_stator, R_rotor, X_stator, X_rotor, X_magnetization, Core_resistance, Core_losses, Friction_losses, power_error] = motor_characterization();

    % Declare variables
    R_C = Core_resistance(Motor_to_analyze); % Core resistance
    P_core = Core_losses(Motor_to_analyze); % Core losses (W)
    P_friction = Friction_losses(Motor_to_analyze); % Friction and windage losses (W)
    X_M = X_magnetization(Motor_to_analyze); % Magnetization reactance
    R_1 = R_stator(Motor_to_analyze); % Stator resistance
    X_1 = X_stator(Motor_to_analyze); % Stator inductance
    BDT = [2.52, 2.2327]; % Breakdown torque
    BDT = BDT(Motor_to_analyze);
    LRT = [0.8196, 0.6499]; % Locked rotor torque
    LRT = LRT(Motor_to_analyze);
    R_2 = R_rotor(Motor_to_analyze); % Rotor resistance
    X_2 = X_rotor(Motor_to_analyze); % Rotor inductance
    Initial_losses = [0, 0]; % Initial losses
    n_synchronization = 1800; % Synchronous speed (RPM)
    V_phi = 230; % Line voltage at full load
    w_synchronization = (n_synchronization * 2 * pi) / 60; % Synchronous speed (rad/s)
    w_motor = (n_motor * 2 * pi) / 60; % Motor speed (rad/s)
    s = (w_synchronization - w_motor) / w_synchronization; % Slip

    % Coefficient of adjustment
    if n_motor < 1600
        alpha = ((BDT - LRT) / 1600) * n_motor + LRT;
    elseif n_motor >= 1600
        alpha = BDT;
    end

    % Rotor impedance
    Z_2 = R_2 / s + 1i * X_2;

    % Calculation of Thevenin voltage
    V_TH = V_phi * (X_M * R_C) / sqrt((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % Calculation of Thevenin impedance
    R_TH = (X_M * R_C * R_1 * (-R_C * R_1 + X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    X_TH = (X_M * R_C * R_1 * (R_C * R_1 - X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    Z_TH = R_TH + 1i * X_TH;

    % Calculation of current I_2
    I_2 = V_TH / sqrt((R_TH + R_2 / s)^2 + (X_TH + X_2)^2);

    % Calculation of air gap power
    P_AG = 3 / alpha * I_2^2 * R_2 / s;

    % Calculation of induced torque
    T_ind = P_AG / w_synchronization;

    % Calculation of load torque
    P_rot = P_friction; % Rotational losses
    T_losses = (P_rot * (1 - s)) / w_motor; % Torque losses

    if T_losses >= Initial_losses(Motor_to_analyze)
        T_load = T_ind - T_losses;
    else
        T_load = T_ind - Initial_losses(Motor_to_analyze);
    end

    torque = T_load;
end
