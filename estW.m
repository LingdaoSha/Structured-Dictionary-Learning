function [Wsource,WS,binary]=estW(source)
%% Removal of non-stained regions from the slide



% W estimate from the target image (V=WH)

% Add path to the spams toolbox
addpath(genpath('spams-matlab'))
start_spams

% Parameter settings
nstains=2;
numpatches=10;
patchsize=300;
Sysize=size(source,1);
Sxsize=size(source,2);
lambda=0.1;  %(Keep this <=1)
count1=0;
binary=zeros(size(source,1),size(source,2));
for k = 1:numpatches,
    patchPos = ceil([rand(1,1)*(Sysize-patchsize+1) rand(1,1)*(Sxsize-patchsize+1)]);
    binary(patchPos(1):patchPos(1)+patchsize-1, patchPos(2):patchPos(2)+patchsize-1)=1;
    patch = source(patchPos(1):patchPos(1)+patchsize-1, patchPos(2):patchPos(2)+patchsize-1,:);
    W=getstainMat(patch, nstains, lambda);
    if sum(sum(W))>0.9
        count1=count1+1;
        WS(:,:,count1)=W;
    end
end
%% Compute medians
wSmed1=[median(WS(1,1,:));median(WS(2,1,:));median(WS(3,1,:))];
wSmed2=[median(WS(1,2,:));median(WS(2,2,:));median(WS(3,2,:))];
Wsource=[wSmed1,wSmed2];
end