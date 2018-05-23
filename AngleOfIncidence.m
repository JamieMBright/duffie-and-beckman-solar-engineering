% angle of incidence, can be derived from the following known constants:
% hour angle
% declination angle
% latitude  (positive north, negative south)
% slope (where 0to90 is increasing tilt towards equator, 90to180 faces the ground)
% surface azimuth angle (where 0 is due south, east is negative and west positive).

function angle_of_incidence = AngleOfIncidence(declination_angle,hour_angle,latitude,tilt,azimuth)

angle_of_incidence = real(acosd( sind(declination_angle).*sind(latitude).*cosd(tilt)...
    -sind(declination_angle).*cosd(latitude).*sind(tilt).*cosd(azimuth)...
    +cosd(declination_angle).*cosd(latitude).*cosd(tilt).*cosd(hour_angle)...
    +cosd(declination_angle).*sind(tilt).*sind(azimuth).*sind(hour_angle) ));

end