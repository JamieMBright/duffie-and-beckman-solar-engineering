% calculate the numver of daylight hours for a specified day of year
function daylight_hours = DaylightHours(latitude, declination_angle)

daylight_hours = 2/15 .*acosd(-tand(latitude).*tand(declination_angle));

end