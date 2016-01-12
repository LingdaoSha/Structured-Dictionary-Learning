% Color normalization
clear


%% Sample random patches of specified size from source images and estimate W per patch and final W=median(Wpatch)
targetFile = dir('TargetImage/*.tif');

target=(imread(['TargetImage/',targetFile(1).name]));     % Read input source file
% Estimate W from sampled target 
[Wt,Wtp,targetbinary]=estW(target);

% Inside the function estW(), you can change different parameters (lambda sparsity parameter, no. of stains, no. of patches, patchsize)
% lambda=0.1 works for most of H&E staining

File = dir('SourceImage/*.tif');
for i = 1:length(File)
source=(imread(['SourceImage/',File(i).name]));    % Read input target file
[Ws,Wsp,sourcebinary]=estW(source);

%% Color normalization
[sourcenorm]=SCN_std(source,Wt,Ws,target,Wsp,Wtp,sourcebinary,File(i).name);   

end
