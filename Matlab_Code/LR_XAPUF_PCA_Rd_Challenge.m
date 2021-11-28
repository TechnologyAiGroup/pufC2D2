

function LR_PCA_Rd_Challenge_Ac=LR_XAPUF_PCA_Rd_Challenge(train_data,train_label,test_data,test_label,chalSize,xAPUFsize)
%train_data:the origin train challenge data
%train_label:the origin train response data
%test_data:the origin test challenge data
%test_label:the origin test response data
%chalSize:the bits number of the XORPUF
%xAPUFsize: Number of APUFs are being XORed
    final_result=[];

    allac=[]; %record intermediate results
    bitnums=32; %the bits of the XORPUF
    d_set=[33]; %the size of the pca matrix
    d2_random=[5,10,15,20];%random select the number of the challenge
    
    
   tm=1;
   Ypset=zeros(1000,50); %used for majority voting
   
   for d2_num=1:size(d2_random,2)
       d2=d2_random(d2_num);
   for randnum=1:50
       
    
    challengeModel_before=train_data;
    challengeModel=train_data; 
    %transform the train set challenge from (0,1) to (-1,1)
    challengeModel = Transform(challengeModel, size(challengeModel,1), size(challengeModel,2));
    
    %transform the train set challenge -1->0
    for i=1:size(challengeModel,1)
        for k=1:size(challengeModel,2)
            if(challengeModel(i,k)==-1)
               challengeModel(i,k)=0;  
            end
        end
    end 

    challengeModel_before01_trans=Transform(challengeModel_before, size(challengeModel_before,1), size(challengeModel_before,2));
    res_real_test=test_label;

    test_chal_data=test_data;
   %transform the test set challenge from (0,1) to (-1,1)
   backTrans=Transform(test_chal_data, size(test_chal_data,1), size(test_chal_data,2));
   test_before_backTrans=backTrans;
   
   
   %transform the test set challenge -1->0
   for j=1:size(backTrans,1)
        for k=1:size(backTrans,2)
            if(backTrans(j,k)==-1)
               backTrans(j,k)=0;  
            end
        end
   end
  
   %get the pca matrix by using the pca function
   d=d_set(tm);
   [coeff, score, LATENT, TSQUARED,explained,mu]=pca(challengeModel);
   train_mean=mean(challengeModel);
   train_pca = score(:,1:d);
   train_pca(:,size(train_pca,2))=1;

   %get the random selected the challenge matrix
   p = randperm(bitnums);
   Top_N=d2;
   IndexSample=p(1:Top_N);
   IndexSample=sort(IndexSample);
   challenge1=zeros(size(train_pca,1),Top_N);

   for i=1:size(IndexSample,2)
       challenge1(:,i)=challengeModel_before01_trans(:,IndexSample(i));
   end
   challenge1(:,Top_N+1:Top_N)=challengeModel_before01_trans(:,bitnums+2:bitnums+1);
   
   %get the train pca data
   train_pca =[challenge1 train_pca];

   
   %deal with the test challenge set
   test_mean=mean(backTrans,1);
   
   %
   test_pca = (backTrans - train_mean)*coeff(:,1:d);
   test_pca(:,size(test_pca,2))=1;

   %get the test pca data
   challenge2=zeros(size(test_pca,1),Top_N);
   for i=1:size(IndexSample,2)
       challenge2(:,i)=test_before_backTrans(:,IndexSample(i));
   end
   challenge2(:,Top_N+1:Top_N)=test_before_backTrans(:,bitnums+2:bitnums+1);
   append_matrix=challenge2;
   test_pca =[append_matrix test_pca];      


   nTrainSize=size(train_pca,1);
   
   %running the LR method
   ac=0;
   while ac<0.9
     [ac, precision, recall,~,Yp]=LR_XAPUF_PCA_GetTestSet(train_pca,train_label,chalSize,xAPUFsize,nTrainSize,test_pca,res_real_test);
   end
   Ypset(:,randnum)=Yp; 
   allac=[allac,ac];
   
   %A majority vote is used every ten times to get the result
   if(mod(randnum,10)==0)
       current_Ypset=Ypset(:,1:randnum);
       test_set_pre= mode(current_Ypset,2);
       [ac_real, precision_real, recall_real, fscore] = accuracy(res_real_test,test_set_pre); 
       final_result=[final_result,ac_real];
   end
   
   fclose all;
   end
   end
  
   LR_PCA_Rd_Challenge_Ac=max(max(final_result));
    
end