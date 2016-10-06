load('mydata2.mat');
size=length(fieldnames(vals));
mylabels=zeros(size,1);
len=length(getfield(vals,'v1'));
mydata=zeros(size,len,'double');

for i=1:size
    tmp=getfield(vals,strcat('v',num2str(i)));
    tmp=transpose(tmp);
    mydata(i,:)=tmp;
    tmplab=getfield(labs,strcat('l',num2str(i)));
    mylabels(i)=tmplab;
end

data                    = zscore(mydata);                 % Scale features, data whitening
numInst                 = size;
numLabels               = max(mylabels);  

numTrain                = 600; 
numTest                 = numInst - numTrain;

trainData=zeros(numTrain,len,'double');
testData=zeros(numTest,len,'double');
trainLabel=zeros(numTrain,1);
testLabel=zeros(numTest,1);
for i=1:numTrain
    trainData(i,:)=data(i,:);
    trainLabel(i)=mylabels(i);
end
for i=1:numTest
    testData(i,:)=data(numTrain+i,:);
    testLabel(i)=mylabels(numTrain+i);
end

%# Train one-against-all models
model                   = cell(numLabels,1);
for k=1:numLabels
    model{k}                = svmtrain(double(trainLabel==k), trainData, '-c 1 -g 0.01 -b 1'); %parameter g=1/num. of features 0.000637755
end

%# Get probability estimates of test instances using each model
prob                    = zeros(numTest,numLabels);
for k=1:numLabels
    [~,~,p]                 = svmpredict(double(testLabel==k), testData, model{k}, '-b 1');
    prob(:,k)               = p(:,model{k}.Label==1);    % Probability of class==k
end

% Predict the class with the highest probability
[~,pred]                = max(prob,[],2);
acc                     = sum(pred == testLabel) ./ numel(testLabel);    % Accuracy
C                       = confusionmat(testLabel, pred);                 % Confusion matrix