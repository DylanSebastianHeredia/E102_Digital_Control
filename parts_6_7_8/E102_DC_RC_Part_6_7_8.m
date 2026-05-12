%% E102: Project II - Digital Control with RC Circuit
% Sebastian Heredia & Alexis Silva
% dheredia@g.hmc.edu & asilva@g.hmc.edu
% May 10, 2026

%%% PART 6 %%%

%% BOX 1: Discretize Plant
% State Space parameters from Part 1-2):
A = [-1/2, 1/2; 0, -2]; 
B = [0; 2];
C = [1, 0];
D = 0;
sys_c = ss(A, B, C, D);     % Enter as state-space matrix format

T = 0.1;    % [sec]
sys_d = c2d(sys_c, T);      % Discretize with T = 0.1s sampling interval

[Ad, Bd, Cd, Dd] = ssdata(sys_d)

% RESULTS:
% Ad = [0.9512    0.0442 ; 0    0.8187]
% Bd = [0.0046 ; 0.1813]
% Cd = [1 0]
% Dd = 0

%% BOX 2 & 3: LQR Design & Ref Gain
% Define linear-quadratic (LQ) state-feedback regulator for DT ss system
Q_100_1 = [100, 0; 0, 1];       % 2x2 Matrix
Q_500_1 = [500, 0; 0, 1];
Q_10_1 = [10, 0; 0, 1];

R = 1;

[K, S, poles_cl] = dlqr(Ad, Bd, Q_100_1, R)
Kr = 1 / (Cd * inv(eye(2) - (Ad - Bd*K)) * Bd)

% For Q11 = 100 and Q22 = 1:

% RESULTS:
% K = [6.5014    1.2697]
% S = [461.9430   38.2567 ; 38.2567    7.6749]
% poles_cl = [0.7549 + 0.1322i ; 0.7549 - 0.1322i]
% Kr = 8.7711

%% BOX 4: Observer Design
% poles_obsv > 2*poles_cl. Record L and poles_obsv values.

poles_obsv = poles_cl.^2
L = place(Ad', Cd', poles_obsv)'

% RESULTS:
% poles_obsv = [0.5524 + 0.1996i ; 0.5524 - 0.1996i]
% L = [0.6651 ; 2.5080]

%%% PART 7 %%%

% Recall: 2.5V step input r[n]
% Recall: 10-second run-time

% Simulation ouput
simulation = sim('e102_digital_control_part7.slx');

t_y_sim = simulation.yout{1}.Values.Time;
y_sim = simulation.yout{1}.Values.Data;

t_u_sim = simulation.yout{2}.Values.Time;
u_sim = simulation.yout{2}.Values.Data;

clf;
figure(1);

% RBG Color Codes:
orange = [1 0.5 0];
green = [0 0.5 0];

plot(t_y_sim, y_sim, 'b-', 'LineWidth', 2);
hold on;
plot(t_u_sim, u_sim, 'r--', 'LineWidth', 2);
grid on;

xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14); 
ylim([0 5.5]);

title('Observer-Based DT State Feedback Step Response (2.5V)', 'FontSize', 14);
legend('y(t)', 'u(t)', 'Location', 'northeast', 'FontSize', 12);

%%% PART 8 %%%

% CHANGE PATH IF NEEDED
expdata = readmatrix('/Users/sebastianheredia/Documents/MATLAB/part8_100_1_PLOT');

% Extract variables
t_exp = expdata(:, 1) - 1.1;  % Remove offset, starts at t = 10sec, align 0 to be the first time entry
y_exp = expdata(:, 2); 
u_exp = expdata(:, 3);

%% Plotting

figure(2);

% Sim
plot(t_u_sim, u_sim, 'r', 'LineWidth', 1); hold on;
plot(t_y_sim, y_sim, 'b', 'LineWidth', 1); hold on;

% Exp
plot(t_exp, u_exp, '--', 'Color', green, 'LineWidth', 1); hold on;
plot(t_exp, y_exp, '--', 'Color', orange, 'LineWidth', 1);

grid on;

xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14); 
ylim([0 5.5]);
xlim([0 10]);   % For 10sec

title('Observer-Based DT State Feedback Step Response (2.5V) Sim vs. Exp', 'FontSize', 14);
legend('Simulated u(t)', 'Simulated y(t)', 'Experimental u[n]', 'Experimental y[n]', 'Location', 'northeast', 'FontSize', 12);

%% FILLING OUT TABLE (PART 8)

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

