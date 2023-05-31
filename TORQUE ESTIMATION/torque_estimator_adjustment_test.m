% -------------------------------------------------------------------------
% TORQUE ESTIMATOR ADJUSTMENT TEST
%
% This script tests the torque estimator function by analyzing different
% motors and their torque characteristics at various speeds. It generates
% a torque versus speed graph and identifies key points such as maximum
% torque, starting torque, full load torque, and minimum torque (if applicable).
%
% The script utilizes the "torque_estimator_adjustment" function to estimate
% the torque for each motor-speed combination.
%
% Written by Douglas Barrantes Alfaro
% Date: May 2023
% -------------------------------------------------------------------------

function [] = torque_estimator_adjustment_test()
    clear;

    % Create an array with input values
    input_values = 0:1:1800;
    upper_limit = max(input_values);

    % Create an array of zeros with the same size as input_values
    results = zeros(1, length(input_values));

    % List of motors to analyze
    motors = [1, 2];

    % Create a figure
    figure;
    title('Torque vs Speed');
    xlabel('Speed [rpm]');
    ylabel('Torque [Nm]');
    hold on;

    for Motor_to_analyze = motors
        % Iterate over each element in the input_values array
        for i = 1:length(input_values)
            % Call the estimador_torque_ajuste function with each input value
            results(i) = estimador_torque_ajuste(Motor_to_analyze, input_values(i));
        end

        % Full load torque
        torque_full_load = [2.116, 1.081];
        torque_full_load = torque_full_load(Motor_to_analyze);
        differences = abs(results - torque_full_load);

        [~, full_load_index] = min(differences);
        value_full_load = [1770, 1765];
        value_full_load = value_full_load(Motor_to_analyze);

        % Plot the results
        plot(input_values, results);

        % Find the maximum value in the results array
        [max_result, max_index] = max(results);

        % Find the corresponding value in the input_values array
        max_value = input_values(max_index);

        % Plot the maximum point with a marker
        p1 = scatter(max_value, max_result, 'r*');
        p2 = scatter(0, results(input_values == 0), 'm*');
        p3 = scatter(value_full_load, torque_full_load, 'b*');

        % Add a label with the coordinates of the point
        text(max_value + 30, max_result, ['(' num2str(max_value) ',' num2str(max_result) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(0 + 30, results(input_values == 0), ['(0,' num2str(results(input_values == 0)) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(value_full_load + 30, torque_full_load, ['(' num2str(value_full_load) ',' num2str(torque_full_load) ')'], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

        % If the upper limit is greater than 1800, find and mark the minimum torque
        if upper_limit > 1800
            [min_result, min_index] = min(results(1801:end));
            min_value = input_values(min_index + 1800);
            p4 = scatter(min_value, min_result, 'g*');
            text(min_value + 30, min_result, ['(' num2str(min_value) ',' num2str(min_result) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        end
    end

    if upper_limit > 1800
        legend('Motor 1', 'Motor 2', 'Maximum Torque', 'Starting Torque', 'Full Load Torque', 'Minimum Torque', 'Location', 'southwest');
    else
        legend('Motor 1', 'Motor 2', 'Maximum Torque', 'Starting Torque', 'Full Load Torque', 'Location', 'southwest');
    end
    hold off;
end


