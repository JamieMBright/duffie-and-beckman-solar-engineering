%Declination is the angular position of the sun at solar noon (i.e. when
%the sun is on the local meridian), with respect to the plane of the eq
%where north is positive. It is derived from day of year, n.
function declination_angle = DeclinationAngle(n)

declination_angle = 23.45.*sind(360.*(284+n)./365);

end