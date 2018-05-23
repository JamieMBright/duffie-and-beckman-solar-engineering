% get information for given latitudes and longitudes and time steps and 
% time zones specified by matlabs inbuilt ones
% ------------------------------------------------------------------------
%                               Inputs
% ------------------------------------------------------------------------
% Latitude, lat - the angular location north or south of the equator, where
%    north is positive. -90 deg <= lat <= 90 deg. Must be in degrees.
%
% Longitude, lon - the angular degrees in degrees west. 0 < lon < 360 deg.
%    This means that prime meridian is 0, and increase as it rotates east.
%
% Time, t - this is matlabs datetime capability where a time zonemust be
%   specified. See the example of how to get fixed start and end time with
%   increments of a 10-minute resolution. For more information, visit 
%   https://au.mathworks.com/help/matlab/ref/datetime.html
%
% Tilt/slope/aspect, tilt - This is the angle between the plane of the
%   suface in question (e.g. the solar panel) and the horizontal. The slope
%   must be 0<= tilt <= 180, where 0 flat to the horizontal panel facing 
%   up, 90 is perpendicular to the horizontal and 180 is flat to the
%   horizontal but facing down. Anthing >90 has a downards component.
%
% Surface azimuth angle/orientation, azi - This is the deviation of the
%   projection on a horizontal plane of the normal to the surface from the
%   local meridian, with zero due south, east negative, and west positive.
%   where -180<= azi <=180
%
% Site elevation/altitude, elev - This is the surface height of the
%   location in kms as measured above sea level. 
%
% ------------------------------------------------------------------------
%                               Limitations
% ------------------------------------------------------------------------
% 1) the input time is only
%

%% example inputs
% % Locations represents:
% % 1) Madison, WI, USA. With a 30 tilt and SSE orientation panel.
% % 2) Rolas Island, Sao Tome and Principe. With a flat panel.
% % 3) ANU, Canberra, Australia. With a 52 tilt and N orientation panel.
% lat = [43.1, 0, -35.2]; 
% lon = [89.4, 353.5, 329.2];
% tilt = [30, 0, 52];
% azi  = [ -22.5, -5, 180];
% elev = [0.266, 0.008, 0.567];
% time_zones = {'America/Chicago','Africa/Sao_Tome','Australia/Sydney'};
% % The timezones must be specified, see timezones('all')
% time_format = 'yyyymmddHHMM';
% start_time = '201801010000';
% end_time = '201901010000';
% resolution_in_minutes = 10;
% datevecs = datevec((datenum(start_time,time_format):resolution_in_minutes/1440:datenum(end_time,time_format)));
% clear t
% for tz = 1:length(time_zones)
%     t(:,tz) = datetime(datevecs,'TimeZone',time_zones{tz});
% end
% clear time_format start_time end_time resolution_in_minutes datevecs tz

function info_struct = DuffieAndBeckman(lat,lon,t,tilt,azi,elev)

% day of year, n.
n = GetN(t);

% extraterrestrial irradiance, E0n.
E0n = ExtraterrestrialIrradiance(n);

% Equaton of time, EoT.
EoT = EquationOfTime(n);

% solar time, ts, and the decimal solar time, tsd.
[~, tsd] = LocalTimeToSolarTime(t,lon,EoT);

% hour angle, ha.
ha = HourAngle(tsd);

% declination angle, dec.
dec = DeclinationAngle(n);

% angle of incidence, AOI.
AOI = AngleOfIncidence(dec,ha,lat,tilt,azi);

% zenith angle, zen.
zen = ZenithAngle(lat,dec,ha);

% air mass, m.
m = AirMass(zen);

% solar azimuth, azs
azs = SolarAzimuthAngle(dec,lat,ha,zen);

% daylight times, dl.
dl = DaylightHours(lat,dec);

% profile angle, pa.
pa = ProfileAngle(zen,azs,azi);

% geometric factor, Rb
Rb = GeometricFactor(AOI,zen);

% clear-sky beam
[Bn, Bch, Tb] = HottelClearSky(elev,zen,E0n);



end







