function td = calculate_XFlow_Spanish_Fork_quantities(td,consts)

%% Wind
td.shear = log(td.U_secondary./td.U)/log(consts.met.secondary_aneometer_height/consts.met.primary_anemometer_height);
td.rho = td.pressure./(consts.met.R*td.temp);
td.mew = (1.458*10^(-6)*td.temp.^(3/2))./(td.temp+110.4); % Sutherland Equation for Dynamic viscosity in Pa-s

%% Torque
td.tau_aero = td.tau_gen - td.acc_sensor.*consts.turb.J;

% if ~isfield(params.processing,'torqueMethod') || strcmp(params.processing.torqueMethod,'raw')
%     % Just use tau_gen
%     out_t.tau_aero = in_t.tau_gen;
%     out_rev.tau_aero = in_t.tau_gen;
% elseif strcmp(params.processing.torqueMethod,'inertiaOnly')
%     % subtract inertia only
%     out_t.tau_aero = in_t.tau_gen + in_t.domega.*params.geom.J;
%     out_rev.tau_aero = in_rev.tau_gen + in_rev.domega.*params.geom.J;
% elseif strcmp(params.processing.torqueMethod,'splineInertia')
%     % full inertia/spring method using splines
%     K = params.processing.splineInertia.K;
%     out_t.tau_aero = params.geom.J.*in_t.domega + in_t.tau_gen + params.geom.J/K.*in_t.ddtorque;
%     out_rev.tau_aero = params.geom.J.*in_rev.domega + in_rev.tau_gen + params.geom.J/K.*in_rev.ddtorque;
% else
%     error('No/bad torqueMethod given in params')
% end
% 
% if params.processing.bearingCorrection
%     out_t.bearingTorque = -133.5563+315.1714*in_t.omega.^0.0807;
%     out_t.tau_aero = out_t.tau_aero + out_t.bearingTorque;
% 
%     out_rev.bearingTorque = -133.5563+315.1714*in_rev.omega.^0.0807;
%     out_rev.tau_aero = out_rev.tau_aero + out_rev.bearingTorque;
% end

%% Loads
% Hub loads
%combined tower forces and moments


%% Power
td.power_gen = td.omega_sensor.*td.tau_gen;
td.power_aero = td.omega_sensor.*td.tau_aero;

%% Non-dimensional quantities
td.TSR = td.omega_sensor*consts.rotor.radius./td.U;
td.Cp_gen = td.power_gen./(0.5*td.rho*consts.turb.A.*td.U.^3);
td.Cp_aero = td.power_aero./(0.5*td.rho*consts.turb.A.*td.U.^3);
td.CQ_gen = td.tau_gen./(0.5*td.rho*consts.turb.A.*td.U.^2*consts.rotor.radius);
td.CQ_aero = td.tau_aero./(0.5*td.rho*consts.turb.A.*td.U.^2*consts.rotor.radius);
td.ReC = (1 + td.TSR).*td.U*consts.rotor.chord.*td.rho./td.mew;