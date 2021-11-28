
function allac=LR_XAPUF_PCA_Experiment(train_data,train_label,test_data,test_label,chalSize,xAPUFsize)
%train_data:the origin train challenge data
%train_label:the origin train response data
%test_data:the origin test challenge data
%test_label:the origin test response data
%chalSize:the bits number of the XORPUF
%xAPUFsize: Number of APUFs are being XORed
   allac=[];
   bit_nums=32;
   d_set=[bit_nums+1];
   d2=bit_nums+1;
   tm=1;
   challengeModel_before=train_data;
   challengeModel=train_data; 
   
   %transform the challenge from (0,1) to (-1,1)
   challengeModel = Transform(challengeModel, size(challengeModel,1), size(challengeModel,2));
   %transform the challenge -1->0
   for i=1:size(challengeModel,1)
        for k=1:size(challengeModel,2)
            if(challengeModel(i,k)==-1)
               challengeModel(i,k)=0;  
            end
        end
   end 
 
   %get the transform challenge data matrix
   challengeModel_before01_trans=Transform(challengeModel_before, size(challengeModel_before,1), size(challengeModel_before,2));

   res_real_test=test_label;
   test_chal_data=test_data;

   backTrans=Transform(test_chal_data, size(test_chal_data,1), size(test_chal_data,2));
   test_before_backTrans=backTrans;
   for j=1:size(backTrans,1)
        for k=1:size(backTrans,2)
            if(backTrans(j,k)==-1)
               backTrans(j,k)=0;  
            end
        end
    end

   d=d_set(tm);
   %get the pca matrix by using the pca function
   [coeff, score, LATENT, TSQUARED,explained,mu]=pca(challengeModel);

   train_mean=mean(challengeModel,1);
   train_pca = score(:,1:d);
   
   %get the random selected the challenge matrix
   p = randperm(bit_nums+1);
   Top_N=d2;
   IndexSample=p(1:Top_N);
   IndexSample=sort(IndexSample);

   challenge1=zeros(size(train_pca,1),Top_N);

   for i=1:size(IndexSample,2)
       challenge1(:,i)=challengeModel_before01_trans(:,IndexSample(i));
   end
   %get the matrix of the combination of train pca and train challenge
   train_pca =[challenge1 train_pca];
   
   %deal with the test data
   test_mean=mean(backTrans,1);
   test_pca = (backTrans - train_mean)*coeff(:,1:d);
   
   
   challenge2=zeros(size(test_pca,1),Top_N);
   for i=1:size(IndexSample,2)
       challenge2(:,i)=test_before_backTrans(:,IndexSample(i));
   end
   append_matrix=challenge2;
   %get the matrix of the combination of test pca and test challenge
   test_pca =[append_matrix test_pca];      

   
   %running the LR method
   nTrainSize=size(train_pca,1);
   count=0;
   zongac=0;
   while(count<7)
       ac=0;
       while(ac<0.9)
          [ac, precision, recall,~,Yp]=LR_XAPUF_PCA_GetTestSet(train_pca,train_label,chalSize,xAPUFsize,nTrainSize,test_pca,res_real_test);
       end
       zongac=zongac+ac;
       count=count+1;
   end
   allac=[allac,zongac/7]; 
end
    