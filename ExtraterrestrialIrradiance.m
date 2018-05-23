% the extra terrestrial irradiance on a normal plane, E0n, depends on the
% solar constant, Esc, and the the day number of the year, n.
function E0n = ExtraterrestrialIrradiance(n,Esc)

% default to Duffie and Beckman's selected solar constant of 1367
if nargin == 1
    Esc = 1367; %Wm-2
end

E0n = Esc.*(1+0.033.*cosd((360.*n)./365));

end