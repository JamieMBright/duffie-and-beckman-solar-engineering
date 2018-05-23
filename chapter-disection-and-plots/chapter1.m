%% Chapter 1 Solar Radiation.

close all

%% User specific variables in order to test
% set location for the Australian National University.
latitude = -35.2;
longitude = 149.2;

% set the time start and end times. All in UTC with format 
time_format = 'yyyymmddHHMM';
start_time = '201801010000';
end_time = '201901010000';
resolution_in_minutes = 10;

%% Pre-cursory time logic
time_stamps = (datenum(start_time,time_format):resolution_in_minutes/1440:datenum(end_time,time_format))';
% derive the "n" variable for these time steps, this describes the day
% number from start of the year. It appears that each year is treated the
% same for the solar geometry options and so we can take advantage of the
% datevector operations in matlab.

% n is slightly different in leap years, this must be considered.
% make datevec
datevecs = datevec(time_stamps);
% extract only the year of each time step
time_year = datevecs(:,1);
% use modulo division by 4 == 0 to indicate leap year
leap_year_ind = mod(time_year,4)==0;
% find the start point of a leap year and non-leap year respectively.
leap_year = datenum([zeros(length(time_stamps),1), datevecs(:,2:end)]) - datenum([0,1,1,0,0,0]);
non_leap_year = datenum([ones(length(time_stamps),1), datevecs(:,2:end)]) - datenum([1,1,1,0,0,0]);
% make an empty n
n =zeros(size(time_stamps));
% fill n with the leap year n or non-leap year n using the indices.
n(leap_year_ind==1) = leap_year(leap_year_ind==1);
n(leap_year_ind==0) = non_leap_year(leap_year_ind==0);

% need a conversion to local time.
[time_zone_offset, daylight_savings] = tzoffset(datetime(datevec(time_stamps)));

%% 1.1 Sun - earth
earth_diameter = 1.27*10^7; %m
sun_diameter = 1.39*10^9; %m
mean_sun_earth_distance = 1.495*10^11; %m or 1 AU

sun_black_body_temperature = 5777; %K
sun_interior_core_temperature_lower = 8*10^6; %K
sun_interior_core_temperature_upper = 40*10^6; %K
sun_density = 100000; %kgm-3;

%% 1.2 solar constant
solar_constant = 1367; %Wm-2

%% 1.3 spectral
lambda = [0,0.25,0.275,0.3,0.325,0.34,0.35,0.36,0.37,0.38,0.39,0.4,0.41,...
    0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.5,0.51,0.52,0.53,0.54,0.55,...
    0.56,0.57,0.58,0.59,0.6,0.62,0.64,0.66,0.68,0.70,0.72,0.74,0.76,0.78,...
    0.8,0.82,0.84,0.86,0.88,0.9,0.92,0.94,0.96,0.98,1,1.05,1.1,1.2,1.3,1.4,...
    1.5,1.6,1.8,2,2.5,3,3.5,4,5,8]';
Gsc_lambda = [0,13.8,224.5,542.3,778.4,912.0,983.0,967.0,1130.8,1070.3,1029.5,...
    1476.9,1698.0,1726.2,1591.1,1837.6,1995.2,2042.6,1996.0,2028.8,1892.4,...
    1918.3,1926.1,1820.9,1873.4,1873.3,1875.0,1841.1,1843.2,1844.6,1782.2,...
    1765.4,1716.4,1693.6,1545.7,1492.7,1416.6,1351.3,1292.4,1236.1,1188.7,...
    1133.3,1089.0,1035.2,967.1,965.7,911.9,846.8,803.8,768.5,763.5,756.5,...
    668.6,591.1,505.6,429.5,354.7,296.6,241.7,169.0,100.7,49.5,25.5,...
    14.3,7.8,2.7,0.8]';
f0_to_lambda = [0,0.002,0.005,0.012,0.023,0.033,0.040,0.047,0.056,0.065,0.071,...
    0.079,0.092,0.104,0.117,0.129,0.143,0.158,0.173,0.187,0.201,0.216,0.230,...
    0.243,0.257,0.271,0.284,0.298,0.311,0.325,0.338,0.351,0.377,0.401,0.424,...
    0.447,0.468,0.488,0.507,0.526,0.544,0.561,0.577,0.593,0.607,0.621,0.635,...
    0.648,0.660,0.671,0.683,0.694,0.720,0.743,0.783,0.817,0.846,0.870,0.890,...
    0.921,0.941,0.968,0.981,0.988,0.992,0.996,0.999]';

% share in each type of irradiance: uv, visible and infra-red.
lambda1 = 0;
lambda2 = 0.38;
lambda3 = 0.78;
lambda4 = 10;
uv_Energy = solar_constant * (f0_to_lambda(knnsearch(lambda,lambda2)) - f0_to_lambda(knnsearch(lambda,lambda1)));
vis_Energy = solar_constant * (f0_to_lambda(knnsearch(lambda,lambda3)) - f0_to_lambda(knnsearch(lambda,lambda2)));
ir_Energy = solar_constant * (f0_to_lambda(knnsearch(lambda,lambda4)) - f0_to_lambda(knnsearch(lambda,lambda3)));

% plot
figure('name','Energy spectrum')
ax = plotyy(lambda,Gsc_lambda,lambda,f0_to_lambda);
hold on
y=0:2500;
plot(ones(size(y)).*lambda2,y,':k')
plot(ones(size(y)).*lambda3,y,':k')
hold off
text(0.1,1500,'UV')
text(0.5,1500,'Vis')
text(1.3,1500,'IR')
xlim([0 2])
ylim([0 2500])
xlabel('Wavelength {\mu}m')
ylabel(ax(1),'Solar spetral irradiance, W/m^2 {\mu}m')
ylabel(ax(2),'CDF of the WRC spectrum')
title('WRC standard spectral irradiance at 1 AU')

% plot
figure('name','solar energy share')
bar([uv_Energy;vis_Energy;ir_Energy]')
xticklabels({'UV','Vis','IR'})
title('Energy proportions of the solar constant')

%% 1.4 Estraterrestrial 
% Variation in intensity assumed constant (though reportedly varies +-
% 1.5%) However, variation in the earth-sun distance is considered.

% extra terrestrial irradiance normal to the radiation on the nth period of the year.
extraterrestrial_irradiance = solar_constant.*(1+0.033.*cosd((360.*n)./365));

% plot
figure('name','extraterrestrial solar radiation')
plot(datetime(datevec(time_stamps)),extraterrestrial_irradiance)
ylabel('G_{0n}, W.m^2')
xlabel('Day of Year')
title('Variation of extraterrestrial solar radiation with time of year')

%% 1.5 Definitions.
% air mass m, the ratio of mass of atmosphere through which beam radiation
% passes to the mass it would pass through if the sun were directly
% overhead (e.g. 1). 
zenith_angle_range = -90:0.1:90;
AM = 1./cosd(zenith_angle_range);

% plot
figure('name','airmass')
plot(zenith_angle_range,AM)
xlabel('Zenith angle (deg)')
ylabel('Air Mass')
ylim([0,10])
xlim([-90,90])
title('Air mass variation with zenith angle')

% solar time. Time based on apparent angular motion of the sun across the
% sky, with solar noon the time the sun crosses the meridian of the
% observer. Note, it does not coincide with local clock time. 
% Correction 1, for difference in longitude and meridian of observer.
% Correction 2, the equation of time that considers pertubations of earth's
% rotation. 
% longitude is in degrees west (i.e. 0deg < L< 360deg).
%equation of time
B = (n-1).*360/365;
EoT = 229.2.*(0.000075+0.001868.*cosd(B)-0.032077.*sind(B)-0.014615.*cosd(2.*B)-0.04089.*sind(2.*B));

%plot
figure('name','Equation of Time')
plot(datetime(datevec(time_stamps)),EoT)
xlabel('Day of year')
ylabel('Equation of time, min')
title('The equation of time in minutes, as a function of time of year')

% find the solar time for ANU at 14:54 05/21/2018, where CBR is +9 and at
% 149.2 latitude (+180 for 0:360 format.
% see function at bottom of script

[solar_time, solar_decimal_time] = LocalTimeToSolarTime(datevec(datenum([2018,01,01,0,0,0])+n),9,longitude);
% find the hour of each n time step as a decimal using the mins and seconds
% of solar time. this can be used to derive the hour angle.

% the hour angle is 15degrees per hour times 1.5 hours before noon. 
hour_angle = 15.*(solar_decimal_time-12/24);

%% 1.6 Direction of Beam Radiation

%Declination is the angular position of the sun at solar noon (i.e. when
%the sun is on the local meridian), with respect to the plane of the eq
%where north is positive.
declination_angle = 23.45.*sind(360.*(284+n)./365);

%plot
figure('name','Declination')
plot(datetime(datevec(time_stamps)),declination_angle)
xlabel('Day of year')
ylabel('Declination angle (degs.)')
title('The solar decliation angle as a function of time of year')
ylim([-23.45 23.45])

% angle of incidence can be derived from the following known constants:
% hour angle, slope(1her 0to90 is increasing tilt towards eq, 90to180 faces
% the ground), declination, latitude (positive north, negative south), and
% surface azimuth angle(where 0 is due south, east is negative and west positive). 

% make different options of slope and azimuth
slope = 0:5:180;
azimuth = -180:15:180;
[S,A] = meshgrid(slope,azimuth);
slopes = reshape(S,[numel(S),1]);
azimuths = reshape(A,[numel(A),1]);

angles_of_incidence=zeros(length(declination_angle),length(azimuths));

for i = 1:length(azimuths)
    angles_of_incidence(:,i)= AngleOfIncidence(declination_angle,hour_angle,latitude,slopes(i),azimuths(i));
end

% the angle of incidence is the angle between thebeam radiation on a
% surface and the normal to that surface. an angle of incidence equal to 0
% means that the plane is perpendicular to the sun. This would result in
% better insolation.

% for a flat surface, the angle of incidence is akin to the zenith angle 
% and is therefore is simplified to
zenith_angle = acosd( cosd(latitude).*cosd(declination_angle).*cosd(hour_angle)+sind(latitude).*sind(declination_angle) );

% repeat the zenith angle to match all orientations calculated in the
% angles of incidence so that a heat map can be plotted.
zenith_angle_rep=repmat(zenith_angle,[1,size(angles_of_incidence,2)]);
% isolate daytime periods by excluding incident angles where zenith>90;
mean_incident_angle_at_day_time = angles_of_incidence;
mean_incident_angle_at_day_time(zenith_angle_rep>90) = NaN;

try
% plot
figure('name','mean angle of incidence at each tilt azi at -35deg latitude')
contourf(slope,azimuth,reshape(prctile(mean_incident_angle_at_day_time,15),[length(azimuth),length(slope)]))
ylabel('azimuth of plane (deg -east : 0 south : +west)')
xlabel('tilt of plane towards equator (0 = flat up, 180 = flat down)')
title({'25^{th} percentile angle of incidence at different panel tilt/azimuths.';'Only daylight hours are considered (\theta_z < 90)';'The lower the angle, the more energy received. 0 = perpendicular to sun'})
xticks(slope)
yticks(azimuth)
xtickangle(90)
colormap('cool')
colorbar
catch
end

% The solar azimuth angle is in the range -180 to 180 degrees. 
% The azimuth angle requires on certain precursors C1 C2 and C3

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

% daylight hours
daylight_hours = 2/15 .*acosd(-tand(latitude).*tand(declination_angle));

% plot
figure('name','daylight hours')
plot(datetime(datevec(time_stamps)), daylight_hours)
xlabel('Time')
title('Number of daylight hours for specified latitude as function of time of year.')

%profile angle
azimuth = 25; 
solar_altitude = asind( cosd(zenith_angle) );
profile_angle = atand( tand(solar_altitude)./cosd(solar_azimuth_angle - azimuth) ); 


%% 1.7 Angles for Tracking Surfaces
% tracking angles for a single adjustment daily that makes beam nomal to
% surface at solar noon. Horizontal axis east-west
tracking_incident_angle_single_daily_adjust = acosd( sind(declination_angle).^2 + cosd(declination_angle).^2.*cosd(hour_angle) );
tracking_slope_single_daily_adjust = abs(ones(size(declination_angle)).*latitude-declination_angle);
tracking_azimuth_angle_single_daily_adjust = zeros(size(declination_angle));
tracking_azimuth_angle_single_daily_adjust((ones(size(declination_angle)).*latitude-declination_angle)>0)=0;
tracking_azimuth_angle_single_daily_adjust((ones(size(declination_angle)).*latitude-declination_angle)<0)=180;

% for a plane rotated about east-west axis with continuous adjustment to
% minmus AOI.Horizontal axis east-west
tracking_angle_of_incidence_continuous_motion = acosd( sqrt(1 - cosd(declination_angle).^2.*sind(hour_angle).^2) );
tracking_slope_continuous_motion = atand( tand(zenith_angle).*abs(cosd(solar_azimuth_angle)) );
tracking_azimuth_angle_continuous_motion = zeros(size(solar_azimuth_angle));
tracking_azimuth_angle_single_daily_adjust(solar_azimuth_angle>0)=90;
tracking_azimuth_angle_single_daily_adjust(solar_azimuth_angle<0)=-90;

% for a plane with fixed slope rotated about a vertical axis. The AOI is
% minimised when the azimuth and solar_azimuth are equal.
fixed_slope = 30;
tracking_angle_of_incidence_fixed_slope_vertical_rotation = ...
    acosd( cosd(zenith_angle).*cosd(fixed_slope) + sind(zenith_angle).*sind(fixed_slope) );
tracking_azimuth_angle_fixed_slope_vertical_rotation = solar_azimuth_angle;

% for a plane rotated about a north-south axis parallel to earths axis with
% continuous adjustment to minimise AOI.
tracking_angle_of_incidence_NS_rotation = acosd(cosd(declination_angle));
tracking_slope_NS_rotation = atand( tand(latitude)./cosd(solar_azimuth_angle) );
tracking_angle_NS_rotation_primed = acosd( cosd(zenith_angle).*cosd(latitude) + sind(zenith_angle).*sind(latitude));
C1_NS_rotated = ones(size(zenith_angle));
C1_NS_rotated((atand((sind(zenith_angle).*sind(solar_azimuth_angle))./(cosd(tracking_angle_NS_rotation_primed).*sind(latitude)))+solar_azimuth_angle) == 0) = 0;
C2_NS_rotated = ones(size(zenith_angle));
C2_NS_rotated(solar_azimuth_angle<0) = -1;
tracking_azimuth_angle_NS_rotation = atand( (sind(zenith_angle).*sind(solar_azimuth_angle))./(cosd(tracking_angle_NS_rotation_primed).*sind(latitude)) + 180.*C1_NS_rotated.*C2_NS_rotated );

% for a plane that is continuously tracking about two axes to minimuse the
% AOI, we can assume that AOI is 0
tracking_angle_of_incidence_dual_axis = 0;
tracking_slope_dual_axis = solar_altitude;
tracking_azimuth_angle_dual_azis = solar_azimuth_angle;

%% 1.8 Ratio of beam radiation on tilted surface to that on horizontal surface.

% the geometric factor Rb is the ratio of beam on tilted to that on a
% horizontal at any time. 
% Rb = Bt/Bh = (Bn*cos(AOI))/(Bn*cos(zen)); therefore Rb = AOI/zenith
Rb = angles_of_incidence ./ zenith_angle;













