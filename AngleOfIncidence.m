% angle of incidence, can be derived from the following known constants:
% hour angle
% declination angle
% latitude  (positive north, negative south)
% slope (where 0to90 is increasing tilt towards equator, 90to180 faces the ground)
% surface azimuth angle (where 0 is due south, east is negative and west positive).

function angle_of_incidence_2 = AngleOfIncidence(dec,ha,lat,tilt,azi,zen,azs)

% calculation from 1.6.2
angle_of_incidence = real(acosd( sind(dec).*sind(lat).*cosd(tilt)...
    -sind(dec).*cosd(lat).*sind(tilt).*cosd(azi)...
    +cosd(dec).*cosd(lat).*cosd(tilt).*cosd(ha)...
    +cosd(dec).*sind(lat).*sind(tilt).*cosd(azi).*cosd(ha)...
    +cosd(dec).*sind(tilt).*sind(azi).*sind(ha) ));

% calculation from 1.6.3
angle_of_incidence_2 = acosd( cosd(zen).*cosd(tilt) + ...
    sind(zen).*sind(tilt).*cosd(azs-repmat(azi,[size(azs,1),1])) );

end