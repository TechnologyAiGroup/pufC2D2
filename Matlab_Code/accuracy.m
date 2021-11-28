

% Confusion Matrix
% -------------------------------------------------------------------------
%  ACTUAL CLASS      TRUE                FALSE    
% -------------------------------------------------------------------------
%  TEST says  TRUE   True Positive(TP)   False positive(FP)
%  TEST says  FLASE  False negative(FN)  True Negative(TN)
% -------------------------------------------------------------------------
% TP rate = TP/(TP+FN)  [called as Sensitivity]
% FN rate = FN/(TP+FN)
% FP rate = FP/(FP+TP)
% TN rate = TN/(FP+TN)  [called as Specificity]
% Accuracy = (TP + TN)/(TP+FN+FP+TN)
% Recall  = [Retrived U Relevent]/Relevant 
%         = TP/(TP+FN)
% Precision = [Retrived U Relevent]/Retrived 
%           = TP/(TP+FP)


function [accuracy precision recall fscore] = accuracy(Y,Yp)

     % True positive [Correctly Accepted]
     TP = sum(Yp == 1 & Y == 1)/sum(Y);
     
     % False positive [Incorrectly Accepted]
     FP = sum(Yp == 1 & Y == 0)/sum(Y==0);
     
     % True negative [Correctly Rejected]
     TN = sum(Yp == 0 & Y == 0)/sum(Y==0);
     
     % False negative [Incorrectly Rejected]
     FN = sum(Yp == 0 & Y == 1)/sum(Y);
     
     accuracy  = (TP + TN)/(TP + FN + FP + TN);
     recall    = TP/(TP + FN);
     precision = TP/(TP + FP);
     fscore = 2 *((recall*precision)/(recall+precision));
    
end