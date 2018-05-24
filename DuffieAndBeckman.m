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
% Non vectorisation for certain statements requiring loop through time
%
% ------------------------------------------------------------------------
%                               Outstanding issues
% ------------------------------------------------------------------------
% 1) seems to be errors at summer time for southern hemisphere. Possibly to
% do with Rb. When running example 2 iterating each compass point for
% southern hemisphere, it is clear that 180=N does not provide best
% solution for tilt. The Ghcs seems to work appropriately, perhaps there
% needs to be a southern hemisphere correction?
%  
%
%
% ------------------------------------------------------------------------
%                               Examples
% ------------------------------------------------------------------------
%                               EXAMPLE 1
% % Locations represents:
% % 1) Madison, WI, USA. With a 30 tilt and SSE orientation panel.
% % 2) Rolas Island, Sao Tome and Principe. With a flat panel.
% % 3) ANU, Canberra, Australia. With a 52 tilt and N orientation panel.
% lat = [43.1, 0, -35.2]; 
% lon = [89.4, 353.5, 329.2];
% tilt = [30, 0, 10];
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
% [Gtc, ~] = DuffieAndBeckman(lat,lon,t,tilt,azi,elev)
% plot(t,Gtc)
% title('Global tilted clear sky irradiance');
% xlabel('local time')
% ylabel('Irradiance (Wm^{-2})')
% names = {'Madison, WI, USA, \beta = 30, \gamma = -22.5/SSE.','Rolas Island, Sao Tome and Principe, \beta = 0, \gamma = NA. ','ANU, Canberra, Australia, \beta = 10, \gamma = 180/N.'};
% legend(names)
%
%                                      EXAMPLE 2
% % site is always Canberra, however, the tilt and azimuth changes
% lat = -35.2; 
% lon = 329.2;
% tilt = [30]; % slowly increaseing tilt
% azi  = (-180:45:180); % 90 = west, -90 = east, 180 and -180 should = N.
% elev = 0.567;
% time_zones = {'Australia/Sydney'};
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
% [Gtc, all_data] = DuffieAndBeckman(lat,lon,t,tilt,azi,elev);
% plot(t,Gtc)
% title('Global tilted clear sky irradiance');
% xlabel('local time')
% ylabel('Irradiance (Wm^{-2})')
% clear names
% for i = 1:length(all_data.tilts)
%     names{i} = ['\beta = ',num2str(all_data.tilts(i)),'. \gamma = ',num2str(all_data.surface_azimuth(i))];
% end
% legend(names)

function [Gtc, all_data] = DuffieAndBeckman(lat,lon,t,tilt,azi,elev)
%% safety checks
% there are precursory examples of input data that have specific
% influences. It should be possible to define 1 latlon and elevation 
% but have 40 tilt azi combos, it should also be possible to have different
% time periods per lat lon. This means that lat=lon=elev must be true,
% however azi~=tilt and t~=lat=lon=elev. 

% check that there is a lat lon and elevation for each site
if max((size(lat)~=size(lon) & size(lat)~=size(elev) & size(elev)~=size(lat)))==1
    error('there must be equal number of lats lons and elevations')
end

% check that there are equal sized tilt and azi. There are different use
% cases for tilt and azi. e.g. 1 tilt for 50 azis. The options are
% therefore that there is either 1 tilt, 1 azi or equal tilt and azi.
if length(tilt)~=length(azi)
    % if there are unequal tilt azi, test to see if there is 1 per
    % repetition of the other
    if (length(tilt)==1 && length(azi)>1)
        tilt = repmat(tilt,size(azi));
    elseif (length(azi)==1 && length(tilt)>1)
        azi = repmat(azi,size(tilt));
    else
        error('there must be either (1) equal number of tilt and azi, (2) 1 value of tilt per value of azi or (3) 1 value of azi per value of tilt')
    end
end

% now check that there is a lat lon pair per tilt azi. There are two
% options here, either there is 1 location per each tilt azi, in which
% case lat lons must be repeated. Else there are equal azi/tilt per
% lat/lon.
% from the above checks, lat=lon and azi=tilt, so only need to check with
% one of the variables.
if length(lat)~=length(azi)
   % 2 options: 1 lat per azi, or 1 azi per lat.
   if length(lat) == 1 && length(azi) > 1
       lat = repmat(lat,size(azi));
       lon = repmat(lon,size(azi));
   elseif length(azi) == 1 && length(lat) > 1
       azi = repmat(azi,size(lat));
       tilt = repmat(tilt,size(lat));
   else
       error(' There must be either (1) a single lat:lon per tilt:azi, (2) a single tilt:azi per lat:lon, or (3) equal lat:lons and tilt:azis')   
   end  
end

% check that there is either 1 time series for all sites, or individual time series
if (size(t,2)~=1 && size(t,2)~=length(lat))
    error('there must be a timeseries for each location, or a single time series for all locations)')
end
% if there is 1 time series per site, repeat it for each location.
if size(t,2)==1
    t=repmat(t,[1,length(lat)]);
end

%% calculations from Duffie and Beckman chapters 1 and 2

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

% zenith angle, zen.
zen = ZenithAngle(lat,dec,ha);

% solar azimuth, azs
azs = SolarAzimuthAngle(dec,lat,ha,zen);

% angle of incidence, AOI.
AOI = AngleOfIncidence(dec,ha,lat,tilt,azi,zen,azs);

% air mass, m.
m = AirMass(zen);

% daylight times, dl.
dl = DaylightHours(lat,dec);

% profile angle, pa.
pa = ProfileAngle(zen,azs,azi);

% geometric factor, Rb
Rb = GeometricFactor(AOI,zen);

% clear-sky beam normal, horizontal and transmission, Bn, Bhc and Tb.
[Bnc, Bhc, Tb] = HottelClearSky(elev,zen,E0n);

% clear-sky diffuse horizontal and transmission, Dhc, Td.
[Dhc, Td] = LiuAndJordan(Tb,E0n);

% global horizontal irradiance, Ghc.
Ghc = Bhc + Dhc;

% clearness index, kT.
kT = ClearnessIndex(Ghc,E0n);

% radiation on a sloped surface, Gt.
[Gtc, Rt] = TiltedRadiationPerez(zen,AOI,Rb,tilt,Ghc,Dhc,Bhc,Bnc,E0n,m);
Gtc(zen>75)=NaN;

% populate output
all_data.angle_of_incidence = AOI;
all_data.surface_azimuth=azi;
all_data.solar_azimuth= azs;
all_data.beam_horizontal_clearsky= Bhc;
all_data.beam_normal_clearsky= Bnc;
all_data.declination= dec;
all_data.diffuse_horizontal_clearsky= Dhc;
all_data.daylight_hours= dl;
all_data.extraterrestrial_normal= E0n;
all_data.site_elevation= elev;
all_data.equation_of_time= EoT;
all_data.global_horizontal_clearsky= Ghc;
all_data.global_tilted_clearsky= Gtc;
all_data.hour_angle= ha;
all_data.clearness_index= kT;
all_data.latitudes = lat;
all_data.longitudes = lon;
all_data.air_mass = m;
all_data.nth_day_of_year = n;
all_data.profile_angle = pa;
all_data.geometric_factor_Rb = Rb;
all_data.geometric_factor_Rt = Rt;
all_data.times = t;
all_data.beam_clearsky_transmission = Tb;
all_data.diffuse_clearsky_transmission = Td;
all_data.tilts = tilt;
all_data.decimal_time = tsd;
all_data.zenith_angle = zen;
end







