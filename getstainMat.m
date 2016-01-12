function [Ws]=getstainMat(I, nstains, lamda)
% Source Input
% I : Patch for W estimation

% Check patch for no stained regions (almost white pixels) and remove those pixels out W
% estimation process

% [I]= checkforNSR(I);


Ivec=reshape(I,size(I,1)*size(I,2),size(I,3));

% convert from Unsigned Integer to Doucble format 

Ivec=Ivec';
Ivecd=double(Ivec);
% Ivecd(Ivecd==0)=1e-7;      % Here, do not replace zero intensities with very small value, otherwise
                             % the W could go wrong 
%% step 1: Beer-Lmabert Law

Ivecd=log(255)-log(Ivecd);

%% step 2: Sparse NMF factorization 

% Include path of SPAMS toolbox

start_spams;

% Settings 

param.mode=2;                           % solves for =min_{D in C} (1/n) sum_{i=1}^n (1/2)||x_i-Dalpha_i||_2^2 + ... 
                                         % lambda||alpha_i||_1 + lambda_2||alpha_i||_2^2
param.lambda=lamda;
% param.lambda2=0.1;
param.posAlpha=true;                    % positive stains 
param.posD=true;                        % positive staining matrix
param.modeD=0;                          % {W in Real^{m x n}  s.t.  for all j,  ||d_j||_2^2 <= 1 }
param.whiten=0;                         % Do not whiten the data                      
param.K=nstains;                        % No. of stain = 2
param.numThreads=-1;                    % number of threads
param.iter=200;                         % 20-50 is OK
% param.batchsize=512;

% Learning W 

Ws=mexTrainDL(Ivecd,param);
% Arranging H stain color vector as first column and then the second column
% vectors as E stain color vector
if Ws(1,1)<Ws(1,2)
    temp=Ws(:,1);
    Ws(:,1)=Ws(:,2);
    Ws(:,2)=temp;
end
