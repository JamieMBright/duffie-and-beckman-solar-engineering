% calculate the Equation of Time, EoT, from the day number, n.
function EoT = EquationOfTime(n)

B = (n-1) .* 360/365;
EoT = 229.2.*(0.000075+0.001868.*cosd(B)-0.032077.*sind(B) - ...
    0.014615.*cosd(2.*B) - 0.04089.*sind(2.*B));

end