%% Chapter 2 Available Solar Radiation

% sections 2.1 to 2.5 are pre amble

%% 2.6 Atmospheric atteunation of solar radiation

% Angstrom turbidity
% beta =;
% Wavelength
% lambda = ;
% single lumped wavelength exponent
% alpha = ;

% tau_a_lambda = exp(-beta.*lambda.^-alpha.*AM);

%% 2.7 Estimation of averagea solar radiation

%% 2.8 Estimation of clear sky radiation


% Hottel beam radiation transmitted through clear atmospheres
% A is the altitude in km
A = 0.5;
climate_zone = 'tropical' ;

% climate correction factors
climate_options = {'tropical','midlatitude_summer','subarctic_summer','midlatitude_winter'};
r0 = [0.95, 0.97, 0.99, 1.03];
r1 = [0.98, 0.99, 0.99, 1.01];
rk = [1.02, 1.02, 1.01, 1.00];
% Hottel derivations
a0 = (0.4237 - 0.00821.*(6 - A).^2) .* r0(strcmp(climate_options,climate_zone));
a1 = (0.5055 + 0.00595.*(6.5 - A).^2) .* r1(strcmp(climate_options,climate_zone));
k = (0.2711 + 0.01858.*(2.5 - A).^2) .* rk(strcmp(climate_options,climate_zone));
% beam transmittance equivalent to Bn/G0n or Bt/G0t
Tb = a0 + a1.*exp(-k./cosd(zenith_angle));

% The clear sky beam normal Bcn irradiance is therefore
Bcn = extraterrestrial_irradiance .* Tb;
% The clear sky beam horizontal irradiance Bch is then
Bch = Bcn .* cosd(zenith_angle);








