% SNMF based stain separation
function [Wi, Hi,Hiv,sepstains]=stainsep(I,nstains,lambda)

% Please cite below paper if you use this code: 

% @inproceedings{Vahadane2015ISBI,
% 	Author = {Abhishek Vahadane and Tingying Peng and Shadi Albarqouni and Maximilian Baust and Katja Steiger and Anna Melissa Schlitter and Amit Sethi and Irene Esposito and Nassir Navab},
% 	Booktitle = {IEEE International Symposium on Biomedical Imaging},
% 	Date-Modified = {2015-01-31 17:49:35 +0000},
% 	Title = {Structure-Preserved Color Normalization for Histological Images},
% 	Year = {2015}}

% Contact: vahadane@iitg.ernet.in, abhishek.vahadane@gmail.com
%% input image should be color image
ndimsI = ndims(I);
if ndimsI ~= 3,
    error('colordeconv:InputImageDimensionError', ...
        'Input image I should be 3-dimensional!');
end
rows=size(I,1);cols=size(I,2);

%% add SPAMS library
addpath(genpath('./spams-matlab'))
start_spams; 

%% Beer-Lamber tranformation
[V, VforW]=BLtrans(I);    % V=WH see in paper, VforW-is V excluding white pixels

% Define parameter for SPAMS toolbox dictionary learning
%param=definePar(nstains,lambda,round(0.1*size(V,1)));    % 0.001-for big size images of size around 1000 by 1000 otherwise factor would be 1 for small resolution images (like around 100 by 100 patch)

param=definePar(nstains,lambda,round(0.1*size(VforW,1))); 
%% Estimate stain color bases
Wi=get_staincolor_sparsenmf(VforW,param);

% Estimate density maps
[Hi,sepstains]=estH(V,Wi,param,rows,cols);
Hiv=vectorise(Hi);
% Hi=reshape(Hi,size(Hi,1)*size(Hi,2),size(Hi,3));
% Hso_Rmax = prctile(Hi(:),95);   % 95 precentile of values in each column
% Hi(Hi>Hso_Rmax)=Hso_Rmax;

end

