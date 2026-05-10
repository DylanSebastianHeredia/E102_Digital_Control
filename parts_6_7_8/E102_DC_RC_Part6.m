%% E102: Project II - Digital Control with RC Circuit
% Sebastian Heredia & Alexis Silva
% dheredia@g.hmc.edu & asilva@g.hmc.edu
% May 9, 2026

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
Q = [100, 0; 0, 1];       % 2x2 Matrix
R = 1;

[K, S, poles_cl] = dlqr(Ad, Bd, Q, R)
Kr = 1 / (Cd * inv(eye(2) - (Ad - Bd*K)) * Bd)

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

% Define ref observer step input
%r = 2.5;       % 2.5V step input r[n]
%time = 10;     % 10-second run-time

% Simulation ouput
simulation = sim('e102_digital_control_part7.slx');

t_y = simulation.yout{1}.Values.Time; % Get time specific to y
y   = simulation.yout{1}.Values.Data;

t_u = simulation.yout{2}.Values.Time; % Get time specific to u
u   = simulation.yout{2}.Values.Data;

clf;
figure(1);

plot(t_y, y, 'b-', 'LineWidth', 2); % Use t_y instead of t
hold on;
plot(t_u, u, 'r--', 'LineWidth', 1.5); % Use t_u instead of t
grid on;

xlabel('Time (s)', 'FontSize', 14);
ylabel('Voltage (V)', 'FontSize', 14); 
ylim([0 5.5]);

title('Observer-Based DT State Feedback Step Response (2.5V)', 'FontSize', 14);
legend('y(t)', 'u(t)', 'Location', 'northeast', 'FontSize', 12);