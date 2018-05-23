% calculate the zenith angle from the latitude, declination and hour angle.
function zenith_angle = ZenithAngle(latitude, declination_angle, hour_angle)
zenith_angle = acosd( cosd(latitude).*cosd(declination_angle).*cosd(hour_angle) ...
    +sind(latitude).*sind(declination_angle) );
end