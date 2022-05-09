clear; clc
data = load('ModelWorkspace.mat');

t_sim = 30; %[s]

%% Vehicle Parameters 
VEH=data.VEH;
wheelB=VEH.FrontAxlePositionfromCG+VEH.RearAxlePositionfromCG;
numWheels=4; % Number of wheels
TrackWidth= VEH.TrackWidth;
InitialLatPosition=0;

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

%% Trasmission Parameters
Trans=data.Trans;

%% Engine Parameters
EngTrqSat=60;

f_tbrake_t_bpt=data.f_tbrake_t_bpt; %[Nm] Breakpoints for commanded torque input
f_tbrake_n_bpt=data.f_tbrake_n_bpt; %[rpm] Breakpoints for engine speed input
NCyl=data.NCyl; % Number of cylinders
Cps=data.Cps; % Crank revolutions per power stroke
Vd=data.Vd; %[m^3] Total displaced volume
Rair=data.Rair; %[J/(kg*K)] Ideal gas constant air
Pstd=data.Pstd; %[Pa] Air standard pressure
Tstd=data.Tstd; %[K] Air standard temperature

f_tbrake=data.f_tbrake; %[Nm] Brake torque map
f_air=data.f_air; %[kg/s] Air mass flow map
f_fuel=data.f_fuel;%[kg/s] Fuel flow map
f_texh=data.f_texh; %[K] Exhaust temperature map
f_eff=data.f_eff; %[g/Kwh] BSFC map
f_hc=data.f_hc; %[kg/s] EO HC map
f_co=data.f_co; %[kg/s] EO CO map
f_nox=data.f_nox; %[kg/s] EO NOx map
f_co2=data.f_co2; %[kg/s] EO CO2 map
f_pm=data.f_pm; %[kg/s] EO PM map

% Accessory load power
AccPwrbp= [0 3.0779560993538198];
AccSpdbp= [256.49641719585139 641.24104298962845];
AfrStoich= 14.6;

%% Environment Parameters
f_mu=ones(4,1); % Ground-to-Wheel friction coefficient

%% Manouver Parameters
t_start=1; %[s] Maneuver start time
t_stop=100; %[s] Steering hold time after max angle reached
omega_hw=13.51; %[deg/s] Handwheel rate
theta_max=270; %[deg] Maximum absolute handwheel angle
xdot_r= 2; % [mph] Longitudinal speed setpoint
ay_max=0.5; %[g] Lateral acceleration absolute threshold
ay_stop=1.3; %[g] Lateral acceleration absolute threshold

% Boolean variables
steerDir=-1;
ss_switch=-1;