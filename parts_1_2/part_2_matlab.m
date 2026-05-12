%% E102: Project II - Digital Control with RC Circuit
% Sebastian Heredia & Alexis Silva
% dheredia@g.hmc.edu & asilva@g.hmc.edu
% May 9, 2026

%% Experimental Data
expdata = readmatrix('/Users/sebastianheredia/Documents/MATLAB/e102_part2_coolterm');
%%% CHANGE PATH IF NEEDED

t_raw = expdata(:, 1) / 10;  % Convert to seconds

% Subtract logging delay to start step at t=0
t_exp = t_raw - 1.1;    % Theoretical time
y_exp = expdata(:, 2);  % Experimental time

%% Theoretical Model
t = linspace(0, max(t_exp), 10E2);

uin = 2.5;      % 2.5V step input
ystep = ((-4/3)*exp(-0.5*t) + (1/3)*exp(-2*t) + 1) * uin;

%% Plotting
clf; clc;

figure(1);

plot(t_exp, y_exp, 'r.', 'MarkerSize', 8);    % Red dots for experimental
hold on;
plot(t, ystep, 'b-', 'LineWidth', 2);         % Blue line for theorical
grid on;

% Crop plot
xlim([0 30])
ylim([0 3])

% Labels
xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14);
title('Open-Loop Step Response (2.5V) of Overdamped 2nd Order RC Circuit', 'FontSize', 14);
legend('Experimental Data', 'Theoretical Model', 'FontSize', 12, 'Location', 'northeast');

