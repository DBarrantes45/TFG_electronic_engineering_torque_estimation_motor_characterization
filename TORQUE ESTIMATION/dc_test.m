% -------------------------------------------------------------------------
% DC TEST
%
% This function calculates the stator resistance at 95°C using the resistance
% values measured at 20°C and the temperature coefficient of copper at 20°C.
%
% Inputs:
%   None
%
% Output:
%   - Stator_Resistance_95_degrees: Stator resistance at 95°C (Ohms)
%
% Written by Douglas Barrantes Alfaro
% Date: May, 2023
% -------------------------------------------------------------------------

function [Stator_Resistance_95_degrees] = dc_test()
    % Initial Variables
    % Stator resistance measured at 20°C
    Stator_Resistance_20_degrees = [7.786941721, 18.39606061];
    % Temperature coefficient of copper at 20°C
    alpha = 3.9e-3;

    % Calculate the resistance at 95°C
    % We use the resistance-temperature formula to extrapolate the data
    for i = 1:length(Stator_Resistance_20_degrees)
        Resistance = Stator_Resistance_20_degrees(i);
        Stator_Resistance_95_degrees(i) = Resistance * (1 + alpha * (95 - 20));
    end
end

