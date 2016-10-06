res=dir('train/*.jpg');
fid=fopen('my_train.txt','w');
for i=1:size(res,1)
    lab=res(i).name;
    if (lab(length(lab)-5)~='_')
    label=[' ' lab(length(lab)-5) lab(length(lab)-4)];
    else
      label=[' ' lab(length(lab)-4)];
    end
    fprintf(fid, strcat(res(i).name,label));
    if (i~=size(res,1))
        fprintf(fid,'\n');
    end
end
fclose(fid);

res=dir('test/*.jpg');
fid=fopen('my_test.txt','w');
for i=1:size(res,1)
    lab=res(i).name;
    if (lab(length(lab)-5)~='_')
    label=[' ' lab(length(lab)-5) lab(length(lab)-4)];
    else
      label=[' ' lab(length(lab)-4)];
    end
    fprintf(fid, strcat(res(i).name,label));
    if (i~=size(res,1))
        fprintf(fid,'\n');
    end
end
fclose(fid);

res=dir('val/*.jpg');
fid=fopen('my_val.txt','w');
for i=1:size(res,1)
    lab=res(i).name;
    if (lab(length(lab)-5)~='_')
    label=[' ' lab(length(lab)-5) lab(length(lab)-4)];
    else
      label=[' ' lab(length(lab)-4)];
    end
    fprintf(fid, strcat(res(i).name,label));
    if (i~=size(res,1))
        fprintf(fid,'\n');
    end
end
fclose(fid);
