% Calculate the air mass, m, as a function of the zenith angle, z
function m = AirMass(z)
m = 1./cosd(z);
end
