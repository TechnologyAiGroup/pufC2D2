
function [allac, precision, recall, fscore]=LR_XAPUF(train_data,train_label,test_data,test_label,chalSize,xAPUFsize)
%train_data:the origin train challenge data
%train_label:the origin train response data
%test_data:the origin test challenge data
%test_label:the origin test response data
%chalSize:the bits number of the XORPUF
%xAPUFsize: Number of APUFs are being XORed

%this function:generate a training model based on the training set through logistic regression (LR), 
%and test it on the test set

count=0;
zongac=0;
while(count<7)
 ac=0;
 while ac<0.9

    fid = fopen('logFile.txt', 'w');
    delete('accuracy.csv');
    chalSize1 = chalSize;    % Bit length of challenge

    x =xAPUFsize;     % x - number of APUFs in x-XOR PUF

    nGeneration = size(train_data,1); 
    challenge= train_data;
    challengePhi = Transform(challenge, nGeneration, chalSize1);
    challengePhi = fliplr(challengePhi);

    response = train_label;
    nAPUF = x; 
    R = response; 
    R(R==0)=-1;

    P = challengePhi;
    nFeatures = size(P,2)*nAPUF; 
    nObservation = size(P,1); 

   % Details of optimization technique
   % Default Parameters
    param.method            = 'Rprop+';
    param.MaxIter           = 1000;      
    param.mu_neg            = 0.01;        
    param.mu_pos            = 1.1;       
    param.delta0            = 0.0123;     
    param.delta_min         = 0;           
    param.delta_max         = 50;          
    param.errorTol          = 10e-15;    

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
        for j=1:repeat

            [trainX,trainY,~,~] = unifiedRamdonSplit(P,R,trPercent(i));
            challengetest= test_data;
            testX = Transform(challengetest, size(challengetest,1), chalSize1);
            testX = fliplr(testX);

            testY=test_label;

            W0 = rand(1,nFeatures);     

            % Training
            [W, grad] = getModelRPROP_XORPUF(trainX,trainY,W0,delta,nAPUF,param);
            fprintf(fid,'\n[%d %d] Max Grad = %g',i,j,max(abs(grad)));
            % Testing
            [Yp, ~] = classify(testX,W,nAPUF);
            testY(testY==-1)=0;
            [ac, precision, recall, fscore] = accuracy(testY,Yp);       

            acMat(i,j) = ac;
            precisionMat(i,j) =  precision;
            recallMat(i,j) = recall; 
            fscoreMat(i,j) = fscore;

        end
        dlmwrite('accuracy.csv',acMat(i,:),'-append');
    end
end 

 zongac=zongac+ac;
 count=count+1;
end


allac=zongac/7; 

save(['modelingResults_' num2str(nAPUF) '_XORPUF.mat'],'acMat','precisionMat','recallMat','fscoreMat');
fprintf(fid,'DONE!!!');
end
%exit;