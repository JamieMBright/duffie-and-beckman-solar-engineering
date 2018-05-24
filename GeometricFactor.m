
% the geometric factor Rb is the ratio of beam on tilted to that on a
% horizontal at any time. 
% Rb = Bt/Bh = (Bn*cos(AOI))/(Bn*cos(zen)); therefore Rb = AOI/zenith
% Calculated using e.q. 1.8.1
function Rb = GeometricFactor(AOI,zen)

Rb = AOI./zen;


end