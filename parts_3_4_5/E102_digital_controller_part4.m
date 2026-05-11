% Plotting Simulation for Part 4

simulation = sim("E102DigitalControllerP4.slx");

t_y = simulation.yout{1}.Values.Time;
y = simulation.yout{1}.Values.Data;

t_u = simulation.yout{2}.Values.Time;
u = simulation.yout{2}.Values.Data;

figure;
plot(t_y, y);
hold on
plot(t_u, u);
xlabel('Time (s)');
ylabel('Output and Input Signals');
title('Simulation Results');
legend('Output y(t)', 'Input u(t)');
hold off;

% Verifying the phase margin and crossover frequency
Kp = 2.35;
Ki = 0.86;
s = tf('s');
C = Kp + Ki/s;
G = 1/(s^2 + 2.5*s +1);
L = C*G;
figure;
margin(L)
grid on
