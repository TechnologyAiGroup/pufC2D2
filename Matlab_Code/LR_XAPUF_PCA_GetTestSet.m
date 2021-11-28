
function [ac, precision, recall, fscore,Yp]=LR_XAPUF_PCA_GetTestSet(train_pca,train_label,chalSize,xAPUFsize,nTrainSize,test_pca,test_label)
   %train_data:the origin train challenge data
   %train_label:the origin train response data
   %test_data:the origin test challenge data
   %test_label:the origin test response data
   %chalSize:the bits number of the XORPUF
   %xAPUFsize: Number of APUFs are being XORed
fid = fopen('logFile.txt', 'w');
chalSize1 = chalSize;    % Bit length of challenge

x =xAPUFsize;     % x - number of APUFs in x-XOR PUF

%generate challenge and response matricies 
nGeneration = nTrainSize; %size of test set
challenge= train_pca;

challengePhi = fliplr(challenge);

response = train_label;
% Number of APUFs are being XORed
nAPUF = x; 
% Compute the XORAPUF output
R = response;   % Response of XORAPUF
R(R==0)=-1;

% Compute features from challenge (Parity vector of challenges)
P = challengePhi;                                                                                                               
nFeatures = size(P,2)*nAPUF; % Number of features for XORAPUF
nObservation = size(P,1);    % Total number of samples

param.method            = 'Rprop+';       
param.mu_neg            = 0.01;        
param.mu_pos            = 1.1; 
param.MaxIter           = 1000;
param.delta0            = 0.0123;     
param.delta_min         = 0;          
param.delta_max         = 50;          
param.errorTol          = 10e-10;     
delta = repmat(param.delta0,1,nFeatures);

trPercent = [100];     
repeat = 1;
nChal = nGeneration;
acMat        = zeros(length(trPercent),repeat);
precisionMat = zeros(length(trPercent),repeat); 
recallMat    = zeros(length(trPercent),repeat); 
fscoreMat    = zeros(length(trPercent),repeat);

% Modeling with various amount of Traing data
for i=1:length(trPercent)
    
    nTrainSample = int64(((nChal+1)*trPercent(i))/100);
    
    % Traing with ramdomly chosen set of samples
    for j=1:repeat
        
        [trainX,trainY,~,~] = unifiedRamdonSplit(P,R,trPercent(i));
        challengetest= test_pca;param.MaxIter=param.MaxIter+500;
        
        testX = fliplr(challengetest);        
        testY=test_label;
        
        W0 = rand(1,nFeatures);          % Initial parameters value
        
        % Training       
        [W, ~] = getModelRPROP_XORPUF(trainX,trainY,W0,delta,nAPUF,param);

        % Testing
        [Yp, ~] = classify(testX,W,nAPUF);
        testY(testY==-1)=0;
        [ac, precision, recall, fscore] = accuracy(testY,Yp); 

        acMat(i,j) = ac;
        precisionMat(i,j) =  precision;
        recallMat(i,j) = recall; 
        fscoreMat(i,j) = fscore;
       
    end
end
% ac=allac_result;
save(['modelingResults_' num2str(nAPUF) '_XORPUF.mat'],'acMat','precisionMat','recallMat','fscoreMat'                                               );

fprintf(fid,'DONE!!!');
end
%exit;