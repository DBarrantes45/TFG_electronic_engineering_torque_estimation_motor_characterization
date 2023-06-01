# TFG_electronics_engineering_torque_estimation_characterization_motors

# CHARACTERIZATION

This repository contains MATLAB scripts for the characterization of electric motors. It provides functions to calculate various motor parameters, including stator resistances, stator and rotor reactances, rotor resistance, magnetizing reactance, power error, and core resistance.

## Content

- `caracterizacion_motores.m`: Main script that characterizes the motor by calling different test functions.
- `prueba_dc.m`: Function to calculate the stator resistance at 95 °C from the resistance values measured at 20 °C and the copper temperature coefficient.
- `prueba_rotor_blocked.m`: Function to calculate the rotor resistance and the reactances of the stator and the rotor using the locked rotor test.
- `prueba_vacio.m`: Function to calculate the magnetization reactance, the power error and the resistance of the core based on measurements and predefined parameters in the no-load test.
- `relaciones_de_potencia.m`: Script to validate the equivalent circuit developed through power relations by comparing the estimated power with the manufacturer's data.

# EQUIVALENT CIRCUIT
This directory contains the file power_relations.m, which is a MATLAB script used to check the validity of the equivalent circuit developed using power relations. This script checks the estimated power against the manufacturer's data, using full load torque and full load speed.

## Content

- `power_relations.m`: This script calculates the estimated powers and compares the results with the expected powers. It uses data for core resistance, core loss, friction loss, magnetizing reactance, stator resistance, stator reactance, rotor resistance, rotor reactance, line current, full load torque, full load speed, and rated voltage. Displays the results in tabular form, including expected power, estimated power, and percent error.

# TORQUE ESTIMATION

This folder contains the files related to estimating the torque of an induction motor. It includes different approaches and functions to calculate torque based on motor characteristics and speed.

## Content

- `Prueba_estimador_torque_adjustment.m`: Script that tests the torque estimator function by analyzing different motors and their torque characteristics at different speeds. Generates a graph of torque vs. speed and identifies key points such as maximum torque, starting torque, full load torque, and minimum torque (if applicable). Use the `fit_torque_estimator` function to estimate the torque.
- `estimador_torque_adjust.m`: Function that estimates the torque of an induction motor based on the motor characteristics provided and the motor speed. Consider factors such as core resistance, losses, reactance, and slip. In addition, it includes tuning variables to control peak torque and starting torque as engine speed increases.
- `torque_estimador_labview.m`: Function that estimates the torque of an induction motor based on real-time measurements of speed and voltage. It is especially useful for implementing in real-time control environments such as LabVIEW.
- `caracterizacion_motores.m`: Main script that characterizes the motor by calling different test functions.
- `prueba_dc.m`: Function to calculate the stator resistance at 95 °C from the resistance values measured at 20 °C and the copper temperature coefficient.
- `prueba_rotor_blocked.m`: Function to calculate the rotor resistance and the reactances of the stator and the rotor using the locked rotor test.
- `prueba_vacio.m`: Function to calculate the magnetization reactance, the power error and the resistance of the core based on measurements and predefined parameters in the no-load test.
- `relaciones_de_potencia.m`: Script to validate the equivalent circuit developed through power relations by comparing the estimated power with the manufacturer's data.

# LabVIEW

This folder contains LabVIEW scripts used for data collection and real-time monitoring of variables of interest such as speed, voltage, and current, as well as indirect torque estimation. It is important to mention that the version used in these scripts was the 2019 version of LabVIEW.

## Content

- `Monitorización de variables.vi`: Script that was used to monitor the variables of interest such as speed, current and voltage, likewise, it makes an approximation of the torque induced by both motors, as well as the automatic control for the connection and disconnection of electrical loads.
- `ControladorPIDparaVelocidad.vi`: Script for the linear PID control used to control the operating speed of the plant.
- `ControladorPIDparaSEIG.vi`: Script used to control the behavior of the self-excited induction generator.
- `Modbus_writing.vi`: File to control the prime mover through the VFD through the modbus protocol.
- `Velocidad_rpm.vi`: Script used to convert and read speed in rpm.
- `Corriente_rms.vi`: File to calculate the rms current generated at the output of the system.
- `Voltaje_rms`: File to calculate the rms voltage generated at the output of the system.
- `Estimador del torque subVI.vi`: File to calculate the torque induced by electric induction motors.

# Use

1. Install MATLAB and LabVIEW `version 2019` on your computer.
2. Clone this repository: `git clone https://github.com/DBarrantes45/TFG_ingenieria_electronica_estimacion_torque_caracterizacion_motores.git`.
3. Run the desired script or call specific functions as needed.

# Author

Douglas Barrantes Alfaro

# Date

May 2023
