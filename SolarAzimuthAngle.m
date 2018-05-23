% The solar azimuth angle is in the range -180 to 180 degrees. 
% The azimuth angle requires on certain precursors C1 C2 and C3

function solar_azimuth_angle = SolarAzimuthAngle(declination_angle, latitude, hour_angle, zenith_angle)

hour_angle_east_west = acosd( tand(declination_angle)./tand(latitude) );

C1 = abs(hour_angle) < hour_angle_east_west;
C1(C1==0) = -1;
C1(abs(tand(declination_angle)./tand(latitude))>1) = 1;

C2 = (latitude.*(ones(size(declination_angle)).*latitude-declination_angle)) >= 0;
C2(C2==0) = -1;

C3 = hour_angle >= 0;
C3(C3==0) = -1;

pseudo_solar_azimuth_angle = asind( (sind(hour_angle).*cosd(declination_angle))./sind(zenith_angle) );
solar_azimuth_angle = C1.*C2.*pseudo_solar_azimuth_angle + C3.*((1-C1.*C2)./2).*180;

% there are possible corrections tha tmust be made for northern and
% southern hemispheres, however, it appears by having sign conventions in
% the latitude, that these are covered for? 
end