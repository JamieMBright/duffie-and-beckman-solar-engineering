
% The tilted irradiance (Gt) firstly establishes the diffuse contributions
% of isotropic (Diso), circumsolar (Dcirc), horizon brightening (Dhrz) and
% reflected irradiance (Drefl). This is then added to the tilted beam
% irradiance.


function [Gtcs, Rt] = TiltedRadiationPerez(zen,AOI,Rb,tilt,Ghc,Dhc,Bhc,Bnc,E0n,m)


% albedo
rho = 0.4; % assumption
Fcs = (1 + cosd(tilt))./2;
Fcg = (1 - cosd(tilt))./2;

% brightness constants
a = zeros(size(AOI));
a(cosd(AOI)>0)=cosd(AOI(cosd(AOI)>0));
b = ones(size(zen)).*cosd(85);
b(cosd(zen)>b)=cosd(zen(cosd(zen)>b));

% clearness
x = 5.535*10^-6;
epsilon = ((Dhc+Bnc)./Dhc + x.*zen.^3) ./ ...
    (1 + x.*zen.^3);

% brightness
delta = m.*Dhc./E0n;

% brightness coefficientes for anisotropic skyes, fii
range_epsilon = repmat([0,1.065,1.230,1.500,1.950,2.8,4.5,6.2,inf],[size(epsilon,1),1]);
f11 = [-0.196,0.236,0.454,0.866,1.026,0.978,0.758,0.318];
f12 = [1.084,0.519,0.321,-0.381,-0.711,-0.986,-0.913,-0.757];
f13 = [-0.006,-0.180,-0.255,-0.375,-0.426,-0.350,-0.236,0.103];
f21 = [-0.114,-0.011,0.072,0.203,0.273,0.280,0.173,0.062];
f22 = [0.180,0.020,-0.098,-0.403,-0.602,-0.915,-1.045,-1.698];
f23 = [-0.019,-0.038,-0.046,-0.049,-0.061,-0.024,0.065,0.236];

% using epsilon, find the indices at each timestep to extract fii;
f_inds = zeros(size(epsilon)).*NaN;
for i = 1:size(epsilon,2)
    f_inds(:,i) = sum(range_epsilon<epsilon(:,i),2);    
end
f_inds(f_inds==0)=1;

% brightness coefficients
F1 = zeros(size(f_inds));
F1_values = f11(f_inds)+f12(f_inds).*delta+(pi.*zen)./180.*f13(f_inds);
F1(F1_values>0)=F1_values(F1_values>0); 

F2 =  f21(f_inds)+f22(f_inds).*delta.*(pi.*zen)./180.*f23(f_inds);

% global tilted irradiance 
Gtcs = Bhc.*Rb + Dhc.*(1-F1).*Fcs + Dhc.*F1.*a./b +...
    Dhc.*F2.*sind(tilt) + Ghc.*rho.*Fcg;

% clean for irregularities
Gtcs(Gtcs<0) = NaN;
Gtcs(zen>90) = NaN;


% ratio of global tilted to horizontal
Rt = Gtcs./Ghc;



end