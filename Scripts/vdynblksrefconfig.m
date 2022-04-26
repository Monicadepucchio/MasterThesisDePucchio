function [varargout]= vdynblksrefconfig(varargin)

%   Copyright 2018-2021 The MathWorks, Inc.

block = varargin{1};
maskMode = varargin{2};
varargout{1} = {};
simStopped = autoblkschecksimstopped(block) && ~(strcmp(get_param(bdroot(block),'SimulationStatus'),'initializing'));
manType = get_param(block,'manType');
vehSys = bdroot(block);
switch maskMode
    case 0
        if simStopped
            switch manType
                case 'Double Lane Change'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','0');
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','1');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','1');                    
                case 'Increasing Steer'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','1');
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','0');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','0');
                case 'Swept Sine'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','2');
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','0');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','0');
                case 'Sine with Dwell'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','3');                    
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','0');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','0');
                case 'Constant Radius'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','4');
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','2');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','1');
                case 'Fishhook'
                    set_param([block '/Reference Generator'],'LabelModeActiveChoice','5');
                    set_param([vehSys '/Visualization/Scope Type'],'LabelModeActiveChoice','0');
                    set_param([vehSys '/Visualization/Vehicle XY Plotter'],'LabelModeActiveChoice','0');
                otherwise
            end
        end
    case 1
        manOverride = strcmp(get_param(block,'manOverride'),'on');
        switch manType
            case 'Double Lane Change'
                autoblksenableparameters(block, [], [],{'DLCGroup'},{'ISGroup';'CRGroup';'SSGroup';'SDGroup';'FHGroup'});
                autoblksenableparameters(block,[],{'steerDir'},[],[],true);
                if simStopped && manOverride
                    set_param([vehSys '/Driver Commands'],'driverType','Longitudinal Driver');
                    set_param([vehSys '/Driver Commands'],'driverType','Predictive Driver');
                    set_param(block,'simTime','25');
                end
            case 'Increasing Steer'
                autoblksenableparameters(block, [], [],{'ISGroup'},{'DLCGroup';'CRGroup';'SSGroup';'SDGroup';'FHGroup'});
                autoblksenableparameters(block,{'steerDir'},[],[],[],true);
                if simStopped && manOverride
                    set_param([vehSys '/Driver Commands'],'driverType','Longitudinal Driver');
                    set_param(block,'simTime','60');                    
                end
            case 'Swept Sine'
                autoblksenableparameters(block, [], [],{'SSGroup'},{'ISGroup';'DLCGroup';'CRGroup';'SDGroup';'FHGroup'});
                autoblksenableparameters(block,[],{'steerDir'},[],[],true);
                if simStopped && manOverride
                    set_param([vehSys '/Driver Commands'],'driverType','Longitudinal Driver');
                    set_param(block,'simTime','40');
                end
            case 'Sine with Dwell'
                autoblksenableparameters(block, [], [],{'SDGroup'},{'ISGroup';'DLCGroup';'CRGroup';'SSGroup';'FHGroup'});
                autoblksenableparameters(block,{'steerDir'},[],[],[],true);
                if simStopped && manOverride
                    set_param([vehSys '/Driver Commands'],'driverType','Longitudinal Driver');
                    set_param(block,'simTime','25');                    
                end
            case 'Constant Radius'
                autoblksenableparameters(block, [], [],{'CRGroup'},{'DLCGroup';'ISGroup';'SSGroup';'SDGroup';'FHGroup'});
                autoblksenableparameters(block,{'steerDir'},[],[],[],true);
                if simStopped && manOverride                    
                    currDriverMode = get_param([vehSys '/Driver Commands'],'driverType');
                    if ~strcmp(currDriverMode,'Predictive Driver') && ~strcmp('updating',get_param(bdroot(block),'SimulationStatus'))
                        set_param([vehSys '/Driver Commands'],'driverType','Predictive Driver');                    
                    end
                    set_param(block,'simTime','60');
                end
            case 'Fishhook'
                autoblksenableparameters(block, [], [],{'FHGroup'},{'ISGroup';'DLCGroup';'CRGroup';'SDGroup';'SSGroup'});
                autoblksenableparameters(block,{'steerDir'},[],[],[],true);
                pFdbkChk = get_param(block,'pFdbk');
                if strcmp(pFdbkChk,'off')
                    autoblksenableparameters(block,{'tDwell1'},{'pZero'},[],[],'false')
                else
                    autoblksenableparameters(block,{'pZero'},{'tDwell1'},[],[],'false')
                end
                if simStopped && manOverride
                    set_param([vehSys '/Driver Commands'],'driverType','Longitudinal Driver');
                    set_param(block,'simTime','40');
                end    
            otherwise
        end
        if simStopped && manOverride && ~strcmp(get_param(block,'prevType'),manType)
            update3DScene(block,manType);
            [~] = vdynblksmdlWSconfig(block,false);
        end
        set_param(block,'prevType',manType)
    case 2
        simStopTime = get_param(block,'simTime');
        set_param(vehSys,'StopTime',simStopTime);
end
end
function update3DScene(block,manType)
sim3DBlkPath = block;
if strcmp(manType,'Double Lane Change')
    set_param(sim3DBlkPath,'SceneDesc','Double lane change');
else
    set_param(sim3DBlkPath,'SceneDesc','Open surface');
end
end
