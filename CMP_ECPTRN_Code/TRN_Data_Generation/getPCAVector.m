function [train_pca] =getPCAVector(trainChallenge)
       d=size(trainChallenge,2);
       challengeModel_0_1=Transform(trainChallenge, size(trainChallenge,1), size(trainChallenge,2));
       test_before_backTrans=challengeModel_0_1;
       
       for j=1:size(challengeModel_0_1,1)
            for k=1:size(challengeModel_0_1,2)
                if(challengeModel_0_1(j,k)==-1)
                   challengeModel_0_1(j,k)=0;  
                end
            end
       end
       
       [coeff, score, LATENT, TSQUARED,explained,mu]=pca(challengeModel_0_1);
      
       train_pca = score(:,1:d);
end