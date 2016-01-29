% Main file to run different color normalization techniques

clear
clc
%% Define source and target images (Add target and source images to the folder "images")
%source=imread('images/source1.png');
%target=imread('images/target1.png');

nstains=2;
lambda=0.02;  % Use smaller values of the lambda (0.01-0.1) for better reconstruction. however, if the normalized image seems not fine, increase or decrease the value accordingly.
% lambda=0.1;
%% Our Method (The techniques is published in ISBI 2015 under the title "STRUCTURE-PRESERVED COLOR NORMALIZATION FOR HISTOLOGICAL IMAGES")
% For queries, contact: abhishek.vahadane@gmail.com, vahadane@iitg.ernet.in
% Source and target stain separation and storage of factors 
targetFile = dir('TargetImage/*.png');

target=(imread(['TargetImage/',targetFile(1).name]));     % Read input source file


[Wi, Hi,Hiv]=stainsep(target,nstains,lambda);

tic

File = dir('SourceImage/*.png');
for i = 1:length(File)
source=(imread(['SourceImage/',File(i).name]));  
[Wis, His,Hivs]=stainsep(source,nstains,lambda);

[our]=SCN(source,Hi,Wi,His,File(i).name);

end

time=toc;


