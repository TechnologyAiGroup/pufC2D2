

% Maintaion 0s/1s ration in train/test data same.
% Divide training set and test set
function [trainX,trainY,testX,testY] = unifiedRamdonSplit(C,R,trPercent)
    
    index0s = find(R==-1);
    index1s = find(R==1);
    
    n0s = length(index0s);             % # 0 response
    n1s = length(index1s);             % # 1 response
    
    n0sTr = int64((n0s*trPercent)/100);
    n1sTr = int64((n1s*trPercent)/100);
    
    indexPerm0s = randperm(n0s);
    indexPerm1s = randperm(n1s);
    
    index0Tr = index0s(indexPerm0s(1:n0sTr));
    index0Te = index0s(indexPerm0s(n0sTr+1:end));
    
    index1Tr = index1s(indexPerm1s(1:n1sTr));
    index1Te = index1s(indexPerm1s(n1sTr+1:end));
    
    indexTr = [index0Tr' index1Tr'];
    indexTe = [index0Te' index1Te'];
    
    trainX = C(indexTr,:);
    trainY = R(indexTr,:);
    testX  = C(indexTe,:);
    testY  = R(indexTe,:);
  
%end