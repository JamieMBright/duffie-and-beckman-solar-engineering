% function to derive the key feature, n from timestamps

function n = GetN(time_stamps)
% derive the "n" variable for these time steps, this describes the day
% number from start of the year. It appears that each year is treated the
% same for the solar geometry options and so we can take advantage of the
% datevector operations in matlab.
n = zeros(size(time_stamps));
for i = 1:size(time_stamps,2)
    % n is slightly different in leap years, this must be considered.
    % make datevec
    datevecs = datevec(time_stamps(:,i));
    % extract only the year of each time step
    time_year = datevecs(:,1);
    % use modulo division by 4 == 0 to indicate leap year
    leap_year_ind = mod(time_year,4)==0;
    % find the start point of a leap year and non-leap year respectively.
    leap_year = datenum([zeros(length(time_stamps(:,i)),1), datevecs(:,2:end)]) - datenum([0,1,1,0,0,0]);
    non_leap_year = datenum([ones(length(time_stamps(:,i)),1), datevecs(:,2:end)]) - datenum([1,1,1,0,0,0]);
    % make an empty n
    n_temp =zeros(size(time_stamps(:,i)));
    % fill n with the leap year n or non-leap year n using the indices.
    n_temp(leap_year_ind==1) = leap_year(leap_year_ind==1);
    n_temp(leap_year_ind==0) = non_leap_year(leap_year_ind==0);
    
    n(:,i) = n_temp;
end
end