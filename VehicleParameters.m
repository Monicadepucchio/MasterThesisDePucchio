clear; clc
data = load('ModelWorkspace.mat');

%% Vehicle Parameters 
VEH=data.VEH;
wheelB=VEH.FrontAxlePositionfromCG+VEH.RearAxlePositionfromCG;
numWheels=4; %Number of wheels

%% Suspension Parameters
Cz=data.Cz; %[Ns/m] Suspension shock damping constant
Kz=data.Kz; %[N/m] Suspension spring constant
Hmax=data.Hmax; %[m] Suspension maximum height

% Independent Axle suspension - MacPherson
F0zMP=data.F0z(1); %[N] Suspension spring preload

% Solid Axle suspension - Coil Spring 
AxlIxx= data.AxlIxx; %[kg*m^2] Axle and wheels lumped principal moments of inertia about longitudinal axis
AxlM= data.AxlM; %[kg] Axle and wheels lumped mass
CzWhlAxl= data.CzWhlAxl; %[Ns/m] Wheel and axle interface damping constant 
KzWhlAxl= data.KzWhlAxl ; %[N/m] Wheel and axle interface compliance constant
F0zCS=data.F0z(2); %[N] Suspension spring preload
F0zWhlAxl= data.F0zWhlAxl; %[N] Wheel and axle interface compliance preload

