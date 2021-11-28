warning('off');


chalSize=32; % Bit length of challenge
xAPUFsize=3; % x - number of APUFs in x-XOR PUF

%load data
test_data=load('XORPUF_3_32_Test_Challenge.mat').XORPUF_3_32_Test_Challenge;


test_label=load('XORPUF_3_32_Test_Response.mat').XORPUF_3_32_Test_Response;

train_data=load('XORPUF_3_32_Train_Challenge.mat').XORPUF_3_32_Train_Challenge;


train_label=load('XORPUF_3_32_Train_Response.mat').XORPUF_3_32_Train_Response;

%comparison of the accuracies of the three methods

% Logisitc Regression
LR_Ac=LR_XAPUF(train_data,train_label,test_data,test_label,chalSize,xAPUFsize);

% PC-enhanced LAD Model I
LR_PCA_Challenge_Ac=LR_XAPUF_PCA_Experiment(train_data,train_label,test_data,test_label,chalSize,xAPUFsize);

% PC-enhanced LAD Model II
LR_PCA_Rd_Challenge_Ac=LR_XAPUF_PCA_Rd_Challenge(train_data,train_label,test_data,test_label,chalSize,xAPUFsize);

