% Calculate the air mass, m, as a function of the zenith angle, z
function m = AirMass(z)
m = 1./cosd(z);
m(z>90)=NaN;
m(m>20)=20;
end
