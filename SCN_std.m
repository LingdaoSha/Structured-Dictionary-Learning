function [sourcenorm]=SCN_std(source,Wt,Ws,target,Wsp,Wtp,sourcebinary,filename)
% Normalize source image to target 

% 
% We provide the open source MATLAB implementation of strucure preserved normalization scheme in the following paper
% to be published in ISBI 2015: 
% 
% Author contact: abhishek.vahadane@gmail.com, vahadane@iitg.ernet.in
%
% BibTex: 
% 
% @inproceedings{Vahadane2015ISBI,
% 	Author = {Abhishek Vahadane and Tingying Peng and Shadi Albarqouni and Maximilian Baust and Katja Steiger and Anna Melissa Schlitter and Amit Sethi and Irene Esposito and Nassir Navab},
% 	Booktitle = {IEEE International Symposium on Biomedical Imaging},
% 	Date-Modified = {2015-01-31 17:49:35 +0000},
% 	Title = {Structure-Preserved Color Normalization for Histological Images},
% 	Year = {2015}}
% 
% Please cite this article if you use it. 
% See instruction.txt for more insights into our algorithm and run of color normalization techniques
% 
%
% ******************************************************************************************************

nstains=size(Ws,2);
%% Check on target stain separation
T=target;
Tvec=reshape(T,size(T,1)*size(T,2),size(T,3));
Tvec=Tvec';
Tvecd=double(Tvec);
Tvecd(Tvecd==0)=1e-7;
Tvecd=log(255)-log(Tvecd);
Ht=(Wt'*Wt)\Wt'*Tvecd;     % Pseudo inverse
resizedHt=reshape(Ht',size(target,1),size(target,2),nstains);
% Separated color stains
for k=1:nstains
    WHt{k}=Wt(:,k)*Ht(k,:);
    colorstaint{k}=uint8(255*exp(-reshape(WHt{k}',size(T,1),size(T,2),size(T,3))));
end

% Target recontruction: 
That=Wt*Ht;
targetrecon=uint8(255*exp(-reshape(That',size(T,1),size(T,2),size(T,3))));
%%

I=source;
Ivec=reshape(I,size(I,1)*size(I,2),size(I,3));

% convert from Unsigned Integer to Doucble format

Ivec=Ivec';
Ivecd=double(Ivec);
Ivecd(Ivecd==0)=1e-7;


%% step 1: Beer-Lmabert Law

Ivecd=log(255)-log(Ivecd);

%% step 2: Sparse NMF factorization

% % Include path of toolbox
% addpath(genpath('E:\Abhishek\Dropbox\TUM\P2_stain separation and color normalization\spams-matlab'));
% start_spams;
% 
% % Settings
% 
% param.mode=2;                           % solves for =min_{D in C} (1/n) sum_{i=1}^n (1/2)||x_i-Dalpha_i||_2^2 + ...
% % lambda||alpha_i||_1 + lambda_2||alpha_i||_2^2
% param.lambda=0.3;
% % param.lambda2=0.1;
% param.posAlpha=true;                    % positive stains
% param.posD=true;                        % positive staining matrix
% param.modeD=0;                          % {W in Real^{m x n}  s.t.  for all j,  ||d_j||_2^2 <= 1 }
% param.whiten=0;                         % Do not whiten the data
% param.K=nstains;                        % No. of stain = 2
% param.numThreads=-1;                    % number of threads
% param.iter=200;                         % 20-50 is OK
% param.pos=1;
% Hs=mexLasso(Ivecd,Ws,param);
% Hs=full(Hs);

% Estimate H to be a pseudo inverse
Hs=(Ws'*Ws)\Ws'*Ivecd;     % Pseudo inverse

resizedHs=reshape(Hs',size(source,1),size(source,2),nstains);
% save('source2stain.mat','Hss')
% save('target_H.mat','Ht')

% Residual
Ds = sqrt(norm(Ivecd-Ws*Hs,'fro'))/(size(Ivecd,1)*size(Ivecd,1));

% Separated color stains
for k=1:nstains
    WHs{k}=Ws(:,k)*Hs(k,:);
    colorstains{k}=uint8(255*exp(-reshape(WHs{k}',size(I,1),size(I,2),size(I,3))));
end


% source reconstruction
Shat2=Ws*Hs;
sourcerecon=uint8(255*exp(-reshape(Shat2',size(source,1),size(source,2),size(source,3))));

%% Color normalization

% Source separation prediction
preds=Ws(1,1)>Ws(1,2);
predt=Wt(1,1)>Wt(1,2);

% swap stain vectors and corresponding densities if needed
if preds~=predt
    w1=Wt(:,1);w2=Wt(:,2); Wt=[w2,w1];
%     % swap H
%     h1=Ht(1,:); h2=Ht(2,:); Ht=[h2;h1];
end

% Convert sparse matrices to full matrices for stretchlim function

% Hs = full(Hs);
% Ht = full(Ht);

% Equalize the dynamic range of the source and target gray stains

% dy_Hs(1,:,:) = stretchlim(Hs(1,:)/max(Hs(1,:))).*max(Hs(1,:));
% dy_Hs(2,:,:) = stretchlim(Hs(2,:)/max(Hs(2,:))).*max(Hs(2,:));
% 
% dy_Ht(1,:,:) = stretchlim(Ht(1,:)/max(Ht(1,:))).*max(Ht(1,:));
% dy_Ht(2,:,:) = stretchlim(Ht(2,:)/max(Ht(2,:))).*max(Ht(2,:));
% Hsnorm=Hs./repmat(dy_Hs(:,2),1,size(Hs,2)).*repmat(dy_Ht(:,2),1,size(Hs,2));

% Normalize source

Ihat=Wt*Hs;

% Back projection into spatial intensity space (Inverse Beer-Lambert space)

sourcenorm=uint8(255*exp(-reshape(Ihat',size(source,1),size(source,2),size(source,3))));

%% Visuals
%
% figure;
% subplot(2,4,1);imshow(source);xlabel('source')
% subplot(2,4,2);imshow(sourcerecon);xlabel('Reconstrued source from separated components')
% subplot(2,4,3);imshow(colorstains{1});xlabel('source stain1 color')
% subplot(2,4,4);imshow(colorstains{2});xlabel('source stain2 color')
% subplot(2,4,5);imshow(target);xlabel('target')
% subplot(2,4,6);imshow(sourcenorm);xlabel('Normalized source')
% subplot(2,4,7);imshow(resizedHs(:,:,1));xlabel('H matrix stain 1')
% subplot(2,4,8);imshow(resizedHs(:,:,2));xlabel('H matrix stain 2')


% imwrite(sourcerecon,'source1recon.png','compression','none')
% imwrite(colorstains{1},'source1stain1.png','compression','none')
% imwrite(colorstains{2},'source1stain2.png','compression','none')
% imwrite(colorstaint{1},'targetstain1.png','compression','none')
% imwrite(colorstaint{2},'targetstain2.png','compression','none')
imwrite(sourcenorm,['NormalizedImage/',filename],'compression','none')
% imwrite(targetrecon,'targetrecon.png','compression','none')
% imwrite(sourcebinary,'source1Sampling.png','compression','none')
%% Save data
% save source, target, Hgray density maps and color stains, Reconstructed
% image after by using separated WH
% save('source1.mat','source','Ws','Wsp','resizedHs','sourcerecon')
% save('target.mat','target','Wt','Wtp','resizedHt','targetrecon')
