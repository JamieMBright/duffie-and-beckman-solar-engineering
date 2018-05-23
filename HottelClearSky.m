
% Hottel beam radiation transmitted through clear atmospheres requires an
% input of the site elevation/altitude, A in km. There is also option to
% add a climate zone.
% the outputs are the clear sky beam normal, Bcn, the clear sky beam
% horizontal, Bch, and the beam transmittance Tb.
% It requires the zenith angle, and the normal extraterrestrial irradiance
% E0n.

function [Bcn, Bch, Tb] = HottelClearSky(A,zenith_angle,E0n,climate_zone)

if nargin<4
    r0 = 1;
    r1 = 1;
    rk = 1;
else
    % climate correction factors
    climate_options = {'tropical','midlatitude_summer','subarctic_summer','midlatitude_winter'};
    
    if ~strcmp(climate_options,climate_zone)
        error('not a valid climate zone')
    end
    
    r0_ = [0.95, 0.97, 0.99, 1.03];
    r1_ = [0.98, 0.99, 0.99, 1.01];
    rk_ = [1.02, 1.02, 1.01, 1.00];
    r0 = r0_(strcmp(climate_options,climate_zone));
    r1 = r1_(strcmp(climate_options,climate_zone));
    rk = rk_(strcmp(climate_options,climate_zone));
end

% Hottel derivations
a0 = (0.4237 - 0.00821.*(6 - A).^2) .* r0;
a1 = (0.5055 + 0.00595.*(6.5 - A).^2) .* r1;
k = (0.2711 + 0.01858.*(2.5 - A).^2) .* rk;
% beam transmittance equivalent to Bn/G0n or Bt/G0t
Tb = a0 + a1.*exp(-k./cosd(zenith_angle));
Tb(Tb<0) = 0;
Tb(Tb>1) = 1;
Tb(zenith_angle>90) = NaN;

% The clear sky beam normal Bcn irradiance is therefore
Bcn = E0n .* Tb;

% The clear sky beam horizontal irradiance Bch is then
Bch = Bcn .* cosd(zenith_angle);



end
