
function [param]= definePar(nstains,lambda,batch)

%% Original mexTrainDL
% DESCRIPTIVE TEXT
% 
% param.mode=2;                           % solves for =min_{D in C} (1/n) sum_{i=1}^n (1/2)||x_i-Dalpha_i||_2^2 + ... 
%                                          % lambda||alpha_i||_1 + lambda_2||alpha_i||_2^2
% param.lambda=lambda;
% % param.lambda2=0.05;
% param.posAlpha=true;                    % positive stains 
% param.posD=true;                        % positive staining matrix
% param.modeD=0;                          % {W in Real^{m x n}  s.t.  for all j,  ||d_j||_2^2 <= 1 }
% param.whiten=0;                         % Do not whiten the data                      
% param.K=nstains;                        % No. of stain = 2
% param.numThreads=-1;                    % number of threads
% param.iter=200;                         % 20-50 is OK
% param.clean=true;
% if ~isempty(batch)
%     param.batchsize=batch;                 % Give here input image no of pixels for trdiational dictionary learning
% end

%% mexStructTrainDL
% DESCRIPTIVE TEXT

param.posAlpha=true;                    % positive stains 
param.posD=true;                        % positive staining matrix

param.modeD=0;                          % {W in Real^{m x n}  s.t.  for all j,  ||d_j||_2^2 <= 1 }
param.whiten=0;                         % Do not whiten the data  

param.lambda=0.05;
param.numThreads=-1; % number of threads
param.batchsize=400;
param.iter=200; 
param.lambda=0.1; % regularization parameter
param.tol=1e-5;
param.K = 2

tree.own_variables=  int32([0 0 3 5 6 6 8 9]);   % pointer to the first variable of each group
tree.N_own_variables=int32([0 3 2 1 0 2 1 1]); % number of "root" variables in each group
tree.eta_g=[1 1 1 2 2 2 2.5 2.5];       
tree.groups=sparse([0 0 0 0 0 0 0 0; ...
                    1 0 0 0 0 0 0 0; ...
                    0 1 0 0 0 0 0 0; ...
                    0 1 0 0 0 0 0 0; ...
                    1 0 0 0 0 0 0 0; ...
                    0 0 0 0 1 0 0 0; ...
                    0 0 0 0 1 0 0 0; ...
                    0 0 0 0 0 0 1 0]);  % first group should always be the root of the tree

param.tree = tree;
param.regul = 'tree-l0';



end