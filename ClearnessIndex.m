% the clearness index is the ratio between the global horizontal irradiance
% (Gh) and the extraterrestrial irradiance (E0n).

function kT = ClearnessIndex(Ghc,E0n)
% calculate the ratio
kT = Ghc ./ E0n;

%set the minimum as suggested by Bendt et al.
kT(kT<0.05) = 0.05;

% set the maximum as derived by Hollands and Huget 1983.
kTmax = 0.6313 + 0.267.*nanmean(kT) - 11.9.*(nanmean(kT)-0.75).^8;
for i = 1:length(kTmax)
    this_kT = kT(:,i);
    
    this_kT(this_kT>kTmax(i)) = kTmax(i);
    
    kT(:,i) = this_kT;
end


end
