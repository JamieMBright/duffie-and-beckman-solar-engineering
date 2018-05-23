% calculate the profile angle
function profile_angle = ProfileAngle(zenith_angle, solar_azimuth_angle, surface_azimuth)

solar_altitude = asind( cosd(zenith_angle) );
profile_angle = real(atand( tand(solar_altitude)./cosd(solar_azimuth_angle - surface_azimuth) )); 

end