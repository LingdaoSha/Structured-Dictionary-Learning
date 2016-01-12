function demo

clear all;


im = imread('im1.tif');

for i =1:3
   m(:,i) = reshape(im(:,:,i), [], 1);
end
 m = double(m)/255;

param.K=64;  % learns a dictionary with 64 elements
param.lambda=0.05;
param.numThreads=4; % number of threads
param.batchsize=400;
param.tol = 1e-3

param.iter=200; 

 
param.lambda=0.1; % regularization parameter
param.tol=1e-5;
param.K = 3

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
fprintf('with Fista %s\n',param.regul);

tic
D1 = mexStructTrainDL(m',param);
t=toc;
fprintf('time of computation for Dictionary Learning: %f\n',t);

tic
D2 = mexTrainDL(m',param);
t=toc;
fprintf('time of computation for Dictionary Learning: %f\n',t);
