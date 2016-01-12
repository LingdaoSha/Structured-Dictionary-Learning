function [HE,C]=macenko_stainsep(I,Io,beta,alpha)


I = double(I);

I = reshape(I, [], 3);

% calculate optical density
OD = -log((I+1)/Io);

% remove transparent pixels
ODhat = OD(~any(OD < beta, 2), :);

% calculate eigenvectors
[V, ~] = eig(cov(ODhat));

% project on the plane spanned by the eigenvectors corresponding to the two
% largest eigenvalues
That = ODhat*V(:,2:3);

% find the min and max vectors and project back to OD space
phi = atan2(That(:,2), That(:,1));

minPhi = prctile(phi, alpha);
maxPhi = prctile(phi, 100-alpha);

vMin = V(:,2:3)*[cos(minPhi); sin(minPhi)];
vMax = V(:,2:3)*[cos(maxPhi); sin(maxPhi)];

% a heuristic to make the vector corresponding to hematoxylin first and the
% one corresponding to eosin second
if vMin(1) > vMax(1)
    HE = [vMin vMax];
else
    HE = [vMax vMin];
end

% rows correspond to channels (RGB), columns to OD values
Y = reshape(OD, [], 3)';

% determine concentrations of the individual stains
% C = HE \ Y;
C = pinv(HE)*Y;
end