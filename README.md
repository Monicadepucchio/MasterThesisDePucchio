This is the De Pucchio's Master Thesis

Files in this repository make use of Matlab&Simulink version R2022a.

The main reference for the plant creation is ISRefernceApplication, example developed by Maathworks in Vehicle Dynamic Blockset.

Model14DOF is the car dynamics model. It comes from Vehicle Dynamics Blockset toolbox.
Passanger Vehicle integrates Model14DOF considering also the engine in Ideal Mapped Engine modul and the trasmission system and the driveline in the Driveline Ideal Fixed Gear modul.

PassangerVehicle is the entire implementation of the model, considering also a driveline given by a fictitious driver and the vehicle engine map.

GeneralFramework implements also Visualization block, a trasmission and clutch control for gear command and a reference generator.

StartUp is the inizialization file. It gives as main output the MAP for the considering vehicle.
