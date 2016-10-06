function [ reduced, explained ] = DemoPCA(multiBand, bandsDesired )
%DEMOPCA Summary of this function goes here
%   Detailed explanation goes here

  % Read/show MultiBand image
  % ----------------------------------------------
%   multiBand = double(multibandread('paris.lan', [512, 512, 7], 'uint8=>uint8', ...                          
%       128,  'bil', 'ieee-le'));
% 
%   figure(1);
%   clf;
%   for i=1:size(multiBand,3)
%     subplot(3,3,i);
%     imshow(multiBand(:,:,i),[]);
%   end
%   
%   set(gcf,'numbertitle','off','name','Original Data');
  
  % PCA computation -> data reduction
  % ------------------------------------------------
%   
%   if ~exist('bandsDesired')
%     bandsDesired = 7;
%   else
%       if bandsDesired > size(multiBand,3)
%           'bands Desired too big ! -> set to maximum value'
%           bandsDesired = size(multiBand,3)
%       end
%   end
%   
  
  dataPCA = reshape(multiBand, [ size(multiBand,1)*size(multiBand,2) size(multiBand,3)]);
  % Each column is a band.
  % Each row is a pixel observation, which is a vector of dimension 7.
  % We will apply PCA to represent each pixel with a vector of dimension 3.
  
  %figure(2);
  %clf;
  %band1 = reshape(dataPCA(:,1), [size(multiBand,1) size(multiBand,2) ]);
  %imshow(band1,[]);
  
  [coeff,score,latent,tsquared,explained,mu] = pca(dataPCA,'NumComponents',bandsDesired);
  
  %size(coeff)  % Coeffs that multiplied with score and addind mu recover the original info 
  %size(score)  % Principal components variance: data reduction of 'dataPCA' onto (rows*cols)x3
  %size(latent) % EigenValues
  %size(explained) % percentage of the total variance explained -> latent/sum(latent)*100
  
  %explained
  
%   'Show subspace projection of first 5 pixels'
%   score(1:5,:)
%    
  reducedBand = reshape(score,[size(multiBand,1) size(multiBand,2), bandsDesired]);
  reduced=reducedBand;
%   figure(2);
%   clf;
%   for i=1:size(reducedBand,3)
%     subplot(3,3,i);
%     imshow(reducedBand(:,:,i),[]);
%   end
%   
%   set(gcf,'numbertitle','off','name','Reduced Data');
%   
  % Reprojection of the reduced data, onto the original space
  % -----------------------------------------------------------
  
  % The following expression requires too much memory
  % Error using repmat
  % Maximum variable size allowed by the program is exceeded.
  % reprojection = score*coeff' + repmat(mu,size(dataPCA,1));
  
%   reprojection = score*coeff';
%   for i=1:size(reprojection,1)
%       reprojection(i,:) = reprojection(i,:) + mu;
%   end
%   
%   recoveredMultiBand = reshape(reprojection,[size(multiBand,1) size(multiBand,2), size(multiBand,3)]);
%   
%   figure(3);
%   clf;
%   % Computation also of the reprojection error for each band
%   repError = [];
%   for i=1:size(multiBand,3)
%     subplot(3,3,i);
%     imshow(recoveredMultiBand(:,:,i),[]);
%     
%     originalBand = multiBand(:,:,i);
%     recoveredBand = recoveredMultiBand(:,:,i);
%     
%     repError(i) = norm(originalBand(:)-recoveredBand(:))/(size(multiBand,1)*size(multiBand,2));
%     title(sprintf('err:%1.3f',repError(i)));  
%   end
%   repError
%   set(gcf,'numbertitle','off','name','Recovered Data');
end

% load('indian_pines_pca');
% [data,explained]=DemoPCA(indian_pines_corrected, 3);

%padded=padarray(data,[32 32]);
% 
% classes=zeros(16,1);
% for i=1:16
%     mask=indian_pines_gt==i;
%     val=sum(mask(:));
%     classes(i)=val;
%     mkdir(num2str(i));
% end

 for i=1:size(data,1)-16
 for j=1:size(data,2)-16
 if (indian_pines_gt(i+8,j+8)~=0)
 imwrite(imcrop(data,[i,j,15,15]),strcat(num2str(i+8),',',num2str(j+8),'_',num2str(indian_pines_gt(i+8,j+8)),'.jpg'),'JPG');
 end
 end
 end
 
for i=1:16
    tmp = dir(strcat('*_',num2str(i),'.jpg'));
    [trainInd,valInd,testInd] = dividerand(size(tmp,1),0.6,0.2,0.2);
    for tr=1:length(trainInd)
        movefile(tmp(trainInd(tr)).name,'train/')
    end
    for va=1:length(valInd)
        movefile(tmp(valInd(va)).name,'val/')
    end
    for te=1:length(testInd)
        movefile(tmp(testInd(te)).name,'test/')
    end
end

