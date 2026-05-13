% E102: Project II - Digital Control with RC Circuit
% Sebastian Heredia & Alexis Silva
% dheredia@g.hmc.edu & asilva@g.hmc.edu

% Simulink Data
simulation = sim("E102DigitalControllerP4.slx");

t_y = simulation.yout{1}.Values.Time;
y_sim = simulation.yout{1}.Values.Data;
t_u = simulation.yout{2}.Values.Time;
u = simulation.yout{2}.Values.Data;

% Experimental Data
expdata = readmatrix("run.txt");

t_raw = expdata(:, 1)*0.1;  % Convert to seconds

% Subtract delay to start jump at t=0
t_exp = t_raw - t_raw(1);
y_exp = expdata(:, 2);  % Experimental output data time
u_exp = expdata(:, 3);  % Experimental input data

% Plotting
clf; clc;
figure(1);
plot(t_exp, u_exp, '--', 'LineWidth', 1, 'Color', [0 0.5 0]);    
hold on;
plot(t_u, u, 'r', 'LineWidth', 1);
plot(t_exp, y_exp, '--', 'Linewidth', 1, 'Color', [1 0.5 0]);
plot(t_y, y_sim, 'b', 'LineWidth', 1);
grid on;
xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14);
title('Experimental vs. Simulated Step Response (2.5V) (K_p = 2.34923 & K_I = 0.85505)');
legend('Input u[n]', 'Input u_{sim}(t)', 'Output y[n]', 'Output y_{sim}(t)');
% ylim([0 10]);
xlim([0 10]);


% Filling out the table
target = 2.5; 
stepTime = 0.1;

% Settling Time (1%)
% Find the last time the signal was more than 0.025V away from 2.5V (aka 1%)
idx = find(abs(y_exp - target) > 0.01*target, 1, 'last');
t_settle = t_exp(idx + 1) - stepTime;

% Maximum Percent Overshoot (Mp)
maxVal = max(y_exp);
fVal = mean(y_exp(end-50:end));         % Final Value (fVal), last 50 points
Mp = 100 * ((maxVal - fVal) / fVal);

% Steady-State Error
ess = abs(target - mean(y_exp(end-10:end)));


uss = mean(u_exp(end-50:end)); % Average of last 50 points
U = sum(abs(u_exp - uss));     % Summation

% RESULTS:
fprintf('t_settle: %.3f\n', t_settle)
fprintf('Mp (percent): %.3f\n', Mp)
fprintf('ess: %.3f\n', ess)
fprintf('U: %.3f\n', U)
