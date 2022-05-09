clear; clc; close all

tic
run("Init_Parameters.m");
open("GeneralFramework.slx")
SimResult = sim('GeneralFramework.slx',t_sim);
toc

figure()
plot(SimResult.tout,SimResult.EngTrqCmd)
ylim([0 90])
xlabel('Time [s]')
ylabel('Engine Torque [N]')
title('Engine Torque Command Behaviour')
grid on

figure()
plot(SimResult.tout,SimResult.SteerOvrCmd)
xlabel('Time [s]')
ylabel(' Steer Command [rad]')
title('Steer Command Behaviour')
grid on

figure()
rho=SimResult.r./SimResult.xdot; % Curvature from the vehicle side
subplot(1,3,1)
plot(SimResult.tout,SimResult.beta)
xlabel('Time [s]')
ylabel('Sided Slip Angle')
subplot(1,3,2)
plot(SimResult.tout,rho)
xlabel('Time [s]')
ylabel('Curvature')
subplot(1,3,3)
plot(rho,SimResult.beta)
xlabel('Sided Slip Angle')
ylabel('Curvature')
grid on
