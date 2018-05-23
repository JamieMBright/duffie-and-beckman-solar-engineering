% calculate the hour angle from the solar time, ts. Where ts is decimal
% time, e.g. 1.5 = 01:30
function hour_angle = HourAngle(tsd)

hour_angle = 15.*(tsd-12/24);

end