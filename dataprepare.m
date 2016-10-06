function dataprepare=dataprepare(data,gt,num_classes)
datapca=struct2cell(load(data));
mydata=cell2mat(datapca);
labs=struct2cell(load(gt));
mylabels=cell2mat(labs);
 for i=1:size(mydata,1)-16
 for j=1:size(mydata,2)-16
 if (mylabels(i+8,j+8)~=0)
 imwrite(imcrop(mydata,[j,i,15,15]),strcat(num2str(i+8),',',num2str(j+8),'_',num2str(mylabels(i+8,j+8)),'.jpg'),'JPG');
 end
 end
 end
 tmp = dir('*.jpg');
   for i=1:size(tmp,1)
       movefile(tmp(i).name,'train/');
   end
 
for i=1:num_classes
    tmp = dir(strcat('*_',num2str(i),'.jpg'));
    [trainInd,valInd,testInd] = dividerand(size(tmp,1),0.8,0.0,0.2);
    for tr=1:length(trainInd)
        movefile(tmp(trainInd(tr)).name,'train/')
    end
    for te=1:length(testInd)
        movefile(tmp(testInd(te)).name,'test/')
    end
end
return;
end
