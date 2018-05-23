% caluclate the solar time as a datevec format by providing the local time
% as a datevec, where GMT difference is the difference of the local time
% from Grenwich mean time. e.g. NSW is +9/10/11 depending on DST.

function [solar_time, solar_decimal_time] = LocalTimeToSolarTime(t, lon, EoT)

% find GMT offset
t_gmt = t;
t_gmt.TimeZone = 'Europe/London';
GMT_difference = round((datenum(t) - datenum(t_gmt)) .*24);

solar_time_diff_to_standard_time = 4.*(lon - 15*GMT_difference) + EoT;
solar_time = datenum(t) + solar_time_diff_to_standard_time/1440;

solar_decimal_time = zeros(length(EoT),length(lon));
for i = 1: length(lon)
    ts = datevec(solar_time(:,i));    
    solar_decimal_time(:,i) = ts(:,4)+ts(:,5)./60+ts(:,6)/(60*60);
end

end