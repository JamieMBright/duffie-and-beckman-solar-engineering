% the Liu and Jordan 1960 method for clear sky diffuse on a horizontal
% surface.
% Td = Dch/E0n = 0.7210-0.294.*Tb
% where Tb is the beam tranmission, Dch is the diffuse horizontal clear sky
% irradiance, E0n is the extraterrestrial irradiance, Td is the diffuse
% horizontal transmission.

function [Dch, Td] = LiuAndJordan(Tb,E0n)

% calculate the diffuse transmission
Td = 0.2710 - 0.294.*Tb;

% the clear sky diffuse horizontal irradiance is then
Dch = E0n .* Td;
end