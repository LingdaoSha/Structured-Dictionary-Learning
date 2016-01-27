function demo

clear all
addpath(genpath('../spams-matlab'))
start_spams; 


im = imread('im1.tif');

for i =1:3
   m(:,i) = reshape(im(:,:,i), [], 1);
end
 m = double(m)/255;
 
 X = m';

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

% tree.own_variables=  int32([0 0 3 5 6 6 8 9]);   % pointer to the first variable of each group
% tree.N_own_variables=int32([0 3 2 1 0 2 1 1]); % number of "root" variables in each group
% tree.eta_g=[1 1 1 2 2 2 2.5 2.5];       
% tree.groups=sparse([0 0 0 0 0 0 0 0; ...
%                     1 0 0 0 0 0 0 0; ...
%                     0 1 0 0 0 0 0 0; ...
%                     0 1 0 0 0 0 0 0; ...
%                     1 0 0 0 0 0 0 0; ...
%                     0 0 0 0 1 0 0 0; ...
%                     0 0 0 0 1 0 0 0; ...
%                     0 0 0 0 0 0 1 0]);  % first group should always be the root of the tree
% 
% param.tree = tree;
% param.regul = 'tree-l0';
% fprintf('with Fista %s\n',param.regul);
% 
% tic
% D1 = mexStructTrainDL(m',param);
% t=toc;
% fprintf('time of computation for Dictionary Learning: %f\n',t);
% 
% tic
% D2 = mexTrainDL(m',param);
% t=toc;
% fprintf('time of computation for Dictionary Learning: %f\n',t);



% param.regul = 'l1';
% fprintf('with Fista Regression %s\n',param.regul);
% tic
% D = mexStructTrainDL(X,param);
% t=toc;
% fprintf('time of computation for Dictionary Learning: %f\n',t);
% %
% param.regul = 'l2';
% fprintf('with Fista Regression %s\n',param.regul);
% tic
% D = mexStructTrainDL(X,param);
% t=toc;
% fprintf('time of computation for Dictionary Learning: %f\n',t);
% %
% param.regul = 'elastic-net';
% fprintf('with Fista %s\n',param.regul);
% param.lambda2=0.1;
% tic
% D = mexStructTrainDL(X,param);
% t=toc;
% fprintf('time of computation for Dictionary Learning: %f\n',t);

%%% GRAPH
param.lambda=0.1; % regularization parameter
param.tol=1e-5;
param.K = 2
graph.eta_g=[1 1 1 1 1];
graph.groups=sparse([0 0 0 1 0;
                     0 0 0 0 0;
                     0 0 0 0 0;
                     0 0 0 0 0;
                     0 0 1 0 0]);   % g5 is included in g3, and g2 is included in g4
graph.groups_var=sparse([1 0 0 0 0; 
                         0 0 0 1 1;]); % represents direct inclusion relations 

param.graph = graph

param.regul = 'graph';
fprintf('with Fista %s\n',param.regul);
tic
D = mexStructTrainDL(X,param);
t=toc;
fprintf('time of computation for Dictionary Learning: %f\n',t);

%%
%%% TREE
%?pause;
param = rmfield(param,'graph');

