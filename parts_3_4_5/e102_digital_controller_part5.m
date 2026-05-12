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
expdata = readmatrix("runitback.txt");

t_raw = expdata(:, 1)*0.1;  % Convert to seconds

% Subtract delay to start jump at t=0
t_exp = t_raw - t_raw(1);
y_exp = expdata(:, 2);  % Experimental output data time
u_exp = expdata(:, 3);  % Experimental input data

% Plotting
clf; clc;
figure(1);
plot(t_exp, u_exp, 'r-');    
hold on;
plot(t_u, u);
plot(t_exp, y_exp, 'b-');
plot(t_y, y_sim);
grid on;
xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14);
title('Experimental vs. Simulated PI Closed-Loop Step Response (2.5V)');
legend('Input u[n]', 'Input u_{sim}(t)', 'Output y[n]', 'Output y_{sim}(t)');
