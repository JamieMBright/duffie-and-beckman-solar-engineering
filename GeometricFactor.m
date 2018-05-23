
% the geometric factor Rb is the ratio of beam on tilted to that on a
% horizontal at any time. 
% Rb = Bt/Bh = (Bn*cos(AOI))/(Bn*cos(zen)); therefore Rb = AOI/zenith
function Rb = GeometricFactor(angle_of_incidence, zenith_angle)
Rb = angle_of_incidence ./ zenith_angle;

end