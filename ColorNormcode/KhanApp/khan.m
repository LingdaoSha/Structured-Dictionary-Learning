
function [sourcenorm]=khan(source,target)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Demonstration of a variety of stain normalization methods.
%
% Adnan Khan 
% Department of Computer Science, 
% University of Warwick, UK.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
imwrite(source,'source.tiff');
imwrite(target,'target.tiff');

%% Stain Normalization using the Proposed Method

% disp('Stain Normalization using the Proposed Method');

fid = fopen( 'filename.txt', 'w+' );
fprintf(fid, '%s\n', 'source.tiff');
fclose(fid);

% if exist(['normalised/', Source], 'file') ==2
%     delete(['normalised/', Source]);
% end
if exist('normalised/', 'dir') == 7
    rmdir('normalised', 's');
end

if exist('normalised/', 'dir')==0
    mkdir('normalised/');
end

dos(['ColourNormalisation.exe BimodalDeconvRVM filename.txt', ...
    ' target.tiff HE.colourmodel']);
% pause(4);
sourcenorm = imread(['normalised/', 'source.tiff']);

% if verbose
%     figure,
%     subplot(131); imshow(ref);   title('Reference Image');
%     subplot(132); imshow(img_src);   title('Source Image');
%     subplot(133); imshow(NormDM);     title('Normalized (Khan)');
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% end

% if exist(['normalised/', Source], 'file') ==2
%     delete(['normalised\', Source]);
% end
pause(10);

if exist('normalised/', 'dir') == 7
    rmdir('normalised', 's');
end

% disp('Press key to continue'); pause;
%%  Comparitive Results

% disp(' Now Displaying all Results for comparison');
% 
% figure,
% subplot(231); imshow(ref);          title('Reference');
% subplot(232); imshow(img_src);      title('Source');
% subplot(233); imshow(NormHS);       title('HistSpec');
% subplot(234); imshow(NormRH);       title('Reinhard');
% subplot(235); imshow(NormMM);       title('Macenko');
% subplot(236); imshow(NormDM);       title('Khan');
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);

end
